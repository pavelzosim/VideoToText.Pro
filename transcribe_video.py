#!/usr/bin/env python3
"""
Video-to-Text Transcription Tool
Simple and reliable script for extracting text from video files.
Uses OpenAI Whisper for maximum recognition accuracy.

Author: Pavel Zosim
GitHub: https://github.com/pavelzosim
LinkedIn: https://www.linkedin.com/in/pavelzosim
Website: https://www.pavelzosim.com
Version: 1.0.0
License: MIT
"""

import os
import sys
import torch
from faster_whisper import WhisperModel
import subprocess
from tqdm import tqdm

# =========================
# 🔧 DEFAULT SETTINGS
# =========================
VIDEO_DIR = "video"
OUTPUT_DIR = "output"
MODEL_SIZE = "medium"
LANGUAGE = None
SAVE_SRT = False
SKIP_EXISTING = True

# Transcription parameters
BEAM_SIZE = 1                           # 1 = fast, 5 = accurate
TEMPERATURE = 0.0                       # 0 = deterministic, >0 = creative
VAD_FILTER = True                       # Voice Activity Detection (skip silence)

# VAD parameters (adjustable)
VAD_MIN_SILENCE_MS = 500                # Minimum silence duration to skip (ms)
VAD_SPEECH_PAD_MS = 400                 # Padding around speech segments (ms)
VAD_MIN_SPEECH_DURATION_MS = 250        # Minimum speech duration to keep (ms)

# Audio extraction settings
EXTRACT_AUDIO = True                    # Extract audio first (faster processing)
AUDIO_SAMPLE_RATE = 16000               # Sample rate in Hz (16kHz recommended for Whisper)

# Load settings from config file if exists (created by .bat)
if os.path.exists("config_temp.py"):
    with open("config_temp.py", "r", encoding="utf-8") as f:
        exec(f.read())
# =========================

def format_timestamp(seconds: float) -> str:
    """Format time for SRT subtitles"""
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = int(seconds % 60)
    millis = int((seconds - int(seconds)) * 1000)
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"

def save_srt(segments, output_path):
    """Save subtitles in SRT format"""
    with open(output_path, 'w', encoding='utf-8') as f:
        for i, seg in enumerate(segments, start=1):
            start = format_timestamp(seg.start)
            end = format_timestamp(seg.end)
            text = seg.text.strip()
            f.write(f"{i}\n{start} --> {end}\n{text}\n\n")

def extract_audio(video_path, audio_path):
    """Extract audio from video using ffmpeg"""
    try:
        subprocess.run([
            "ffmpeg", "-i", video_path,
            "-vn",                              # No video
            "-acodec", "pcm_s16le",             # PCM 16-bit
            "-ar", str(AUDIO_SAMPLE_RATE),     # Sample rate
            "-ac", "1",                         # Mono
            "-y",                               # Overwrite
            audio_path
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        return False

def get_file_size_mb(file_path):
    """Get file size in MB"""
    return os.path.getsize(file_path) / (1024 * 1024)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    device = "cuda" if torch.cuda.is_available() else "cpu"
    compute_type = "float16" if device == "cuda" else "int8"
    
    print("=" * 70)
    print("🎙️  VIDEO TO TEXT TRANSCRIPTION")
    print("=" * 70)
    
    if device == "cuda":
        print(f"🚀 Using GPU: {torch.cuda.get_device_name(0)}")
    else:
        print("⚠️  Using CPU (will be slower)")
    
    print(f"📥 Loading Whisper model: {MODEL_SIZE}")
    print(f"   Settings: beam_size={BEAM_SIZE}, vad_filter={VAD_FILTER}")
    if LANGUAGE:
        print(f"   Language: {LANGUAGE}")
    
    model = WhisperModel(MODEL_SIZE, device=device, compute_type=compute_type)
    print("✅ Model loaded successfully\n")
    
    video_extensions = (".mp4", ".mov", ".avi", ".mkv", ".webm", ".flv", ".wmv", ".m4v")
    video_files = [f for f in os.listdir(VIDEO_DIR) 
                   if f.lower().endswith(video_extensions)]
    
    if not video_files:
        print(f"❌ No video files found in '{VIDEO_DIR}' folder")
        print(f"   Please place video files in the '{VIDEO_DIR}' directory")
        input("\nPress Enter to exit...")
        return
    
    print(f"📊 Found {len(video_files)} file(s)\n")
    
    success_count = 0
    skipped_count = 0
    error_count = 0
    
    with tqdm(total=len(video_files), desc="Overall Progress", unit="file", ncols=100, 
              bar_format='{l_bar}{bar}| {n_fmt}/{total_fmt} [{elapsed}<{remaining}]') as pbar:
        
        for filename in video_files:
            video_path = os.path.join(VIDEO_DIR, filename)
            base_name = os.path.splitext(filename)[0]
            txt_path = os.path.join(OUTPUT_DIR, f"{base_name}.txt")
            srt_path = os.path.join(OUTPUT_DIR, f"{base_name}.srt")
            audio_path = os.path.join(OUTPUT_DIR, f"{base_name}.wav")
            
            if SKIP_EXISTING and os.path.exists(txt_path):
                pbar.set_description(f"⏭️  Skipping: {filename[:40]}")
                skipped_count += 1
                pbar.update(1)
                continue
            
            pbar.set_description(f"🎬 Processing: {filename[:40]}")
            
            try:
                # Extract audio if enabled
                use_audio = False
                if EXTRACT_AUDIO:
                    use_audio = extract_audio(video_path, audio_path)
                    if not use_audio:
                        pbar.write(f"   ⚠️  FFmpeg not found or failed, using video directly")
                
                input_file = audio_path if use_audio else video_path
                file_size = get_file_size_mb(input_file)
                
                # Build VAD parameters
                vad_params = None
                if VAD_FILTER:
                    vad_params = {
                        'min_silence_duration_ms': VAD_MIN_SILENCE_MS,
                        'speech_pad_ms': VAD_SPEECH_PAD_MS,
                        'min_speech_duration_ms': VAD_MIN_SPEECH_DURATION_MS
                    }
                
                # Transcription
                segments, info = model.transcribe(
                    input_file,
                    language=LANGUAGE,
                    beam_size=BEAM_SIZE,
                    temperature=TEMPERATURE,
                    vad_filter=VAD_FILTER,
                    vad_parameters=vad_params
                )
                
                # Collect segments with nested progress bar
                segments_list = []
                for seg in tqdm(segments, desc="   Transcribing", unit="seg", 
                               leave=False, ncols=100, disable=file_size < 10):
                    segments_list.append(seg)
                
                if not segments_list:
                    pbar.write(f"   ⚠️  No speech detected in {filename}")
                    error_count += 1
                    pbar.update(1)
                    continue
                
                # Collect text
                text = " ".join([seg.text.strip() for seg in segments_list])
                
                # Save text file
                with open(txt_path, "w", encoding="utf-8") as f:
                    f.write(text.strip())
                
                # Save SRT subtitles if enabled
                if SAVE_SRT and segments_list:
                    save_srt(segments_list, srt_path)
                
                # Clean up temporary audio file
                if use_audio and os.path.exists(audio_path):
                    try:
                        os.remove(audio_path)
                    except:
                        pass  # Ignore cleanup errors
                
                # Calculate stats
                word_count = len(text.split())
                duration = segments_list[-1].end if segments_list else 0
                
                pbar.write(f"   ✅ {base_name}.txt ({word_count} words, {duration:.1f}s)")
                success_count += 1
                
            except Exception as e:
                pbar.write(f"   ❌ Error processing {filename}: {e}")
                error_count += 1
                
                # Clean up on error
                if os.path.exists(audio_path):
                    try:
                        os.remove(audio_path)
                    except:
                        pass
            
            pbar.update(1)
    
    # Summary
    print("\n" + "=" * 70)
    print("📊 SUMMARY:")
    print(f"   Total files: {len(video_files)}")
    print(f"   ✅ Processed: {success_count}")
    print(f"   ⏭️  Skipped: {skipped_count}")
    print(f"   ❌ Errors: {error_count}")
    print("=" * 70)
    
    if success_count > 0:
        print(f"\n💾 Output files saved to: {os.path.abspath(OUTPUT_DIR)}")
    
    input("\nPress Enter to exit...")

if __name__ == "__main__":
    main()