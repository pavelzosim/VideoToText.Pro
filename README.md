## 👨‍💻 Author

**Pavel Zosim** - Tecnical Artist & Developer

- 🔗 **GitHub:** [@pavelzosim](https://github.com/pavelzosim)
- 💼 **LinkedIn:** [Pavel Zosim](https://www.linkedin.com/in/pavelzosim)
- 🌐 **Website:** [pavelzosim.com](https://www.pavelzosim.com)
- 📧 **Email:** pavel.zosim@protonmail.com

### 🤝 Support the Project

If this tool saved you time, consider:
- ⭐ **Starring this repository**
- 🐛 **Reporting bugs** via GitHub Issues
- 💡 **Suggesting features**
- 🔀 **Contributing** via pull requests

---

**Made with ❤️ by Pavel Zosim**


# 🎙️ Video-to-Text Transcription Tool

A fast, reliable, and user-friendly tool for extracting text from video files using OpenAI's Whisper model. Perfect for content creators, researchers, and anyone who needs accurate video transcriptions.

## ✨ Features

- **🚀 GPU Acceleration** - Blazing fast transcription with NVIDIA CUDA support
- **🎯 High Accuracy** - Powered by OpenAI Whisper models (tiny to large)
- **🌍 Multi-Language** - Supports 99+ languages with auto-detection
- **📝 Multiple Formats** - Export as TXT or SRT subtitles
- **⚡ Smart Processing** - Voice Activity Detection to skip silence
- **🔄 Batch Processing** - Process multiple videos automatically
- **💻 Easy to Use** - Interactive menu interface (no coding required)
- **🎛️ Customizable** - Fine-tune all transcription parameters

## 📋 Requirements

- Python 3.8 or higher
- NVIDIA GPU (optional, but recommended for speed)
- FFmpeg (for faster audio extraction)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/pavelzosim/VideoToText.Pro.git
cd video-transcription-tool
```

### 2. Install Dependencies

**For CPU only:**
```bash
pip install -r requirements.txt
```

**For GPU acceleration (Windows):**
```bash
# Run the automated installer
install_gpu.bat

# Or install manually:
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install faster-whisper tqdm
```

### 3. Verify Installation

```bash
python check_installation.py
```

### 4. Run Transcription

**Windows (Easy Mode):**
```bash
run_transcription.bat
```

**Direct Python:**
```bash
python transcribe_video.py
```

## 📁 Folder Structure

```
video-transcription-tool/
├── transcribe_video.py      # Main transcription script
├── check_installation.py    # Verify GPU and dependencies
├── run_transcription.bat    # Interactive menu launcher
├── install_gpu.bat          # GPU setup automation
├── requirements.txt         # Python dependencies
├── video/                   # 📂 Place your videos here
└── output/                  # 📂 Transcriptions saved here
```

## 🎛️ Configuration Options

### Model Sizes

| Model | Speed | Accuracy | VRAM Required |
|-------|-------|----------|---------------|
| `tiny` | ⚡⚡⚡⚡⚡ | ⭐⭐ | ~1 GB |
| `base` | ⚡⚡⚡⚡ | ⭐⭐⭐ | ~1 GB |
| `small` | ⚡⚡⚡ | ⭐⭐⭐⭐ | ~2 GB |
| `medium` | ⚡⚡ | ⭐⭐⭐⭐⭐ | ~5 GB |
| `large` | ⚡ | ⭐⭐⭐⭐⭐ | ~10 GB |

**Recommended:** `medium` for best balance of speed and quality

### Supported Languages

English, Spanish, French, German, Italian, Portuguese, Russian, Chinese, Japanese, Korean, Arabic, Hindi, and 90+ more languages.

### Advanced Features

- **Beam Size:** Control accuracy vs speed (1=fast, 5=accurate)
- **VAD Filter:** Automatically skip silence in videos
- **Audio Extraction:** Pre-extract audio for faster processing
- **SRT Export:** Generate subtitle files
- **Batch Processing:** Handle multiple videos automatically

## 💡 Usage Examples

### Basic Transcription

1. Place video files in the `video/` folder
2. Run `run_transcription.bat`
3. Press `[R]` to start
4. Find transcriptions in `output/` folder

### Custom Settings

Edit settings in `transcribe_video.py`:

```python
MODEL_SIZE = "medium"        # tiny/base/small/medium/large
LANGUAGE = "en"              # or None for auto-detect
SAVE_SRT = True              # Generate subtitle files
BEAM_SIZE = 5                # Higher = more accurate
VAD_FILTER = True            # Skip silence
```

### Command Line

```bash
# Quick transcription with defaults
python transcribe_video.py

# With custom model
python transcribe_video.py --model large --language en
```

## 🎯 Performance

### Speed Comparison (10-minute video)

| Hardware | Model | Time | Speed |
|----------|-------|------|-------|
| CPU (i7-12700) | medium | ~45 min | 0.22x |
| GPU (RTX 4060) | medium | ~3 min | 3.3x |
| GPU (RTX 4090) | large | ~2 min | 5.0x |

*Results vary based on audio complexity and settings*

## 🔧 Troubleshooting

### GPU Not Detected

```bash
# Run diagnostics
python check_installation.py

# Reinstall PyTorch with CUDA
pip uninstall torch
pip install torch --index-url https://download.pytorch.org/whl/cu121
```

### FFmpeg Not Found

Download from: https://www.gyan.dev/ffmpeg/builds/
- Extract and add to PATH
- Or place `ffmpeg.exe` in tool folder

### Out of Memory Error

- Use smaller model (e.g., `small` instead of `medium`)
- Enable audio extraction (`EXTRACT_AUDIO = True`)
- Process videos one at a time

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [faster-whisper](https://github.com/guillaumekln/faster-whisper) by Guillaume Klein
- Powered by [OpenAI Whisper](https://github.com/openai/whisper)
- Uses [CTranslate2](https://github.com/OpenNMT/CTranslate2) for optimization

## 📧 Contact

- GitHub: [@yourusername](https://github.com/pavelzosim)
- LinkedIn: [Your Name](https://www.linkedin.com/in/pavelzosim)
- Website: [yourwebsite.com](https://www.pavelzosim.com)

## ⭐ Star History

If you find this tool useful, please consider giving it a star on GitHub!

---

**Made with ❤️ for content creators and researchers**