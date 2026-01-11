````md
```text
============================================================
   PAVEL ZOSIM
   CODE x ART x AUTOMATE
============================================================
````

# Video-to-Text Transcription Tool

A CLI tool for extracting text from video files using OpenAI Whisper models.

Designed for fast, reliable transcription workflows with optional GPU acceleration.
Built for developers, technical artists, researchers, and content creators.

---

## Features

* GPU-accelerated transcription (CUDA supported)
* High-quality speech recognition via Whisper models
* Multi-language support with auto-detection
* Export formats:

  * TXT
  * SRT (subtitles)
* Batch processing of multiple video files
* Voice Activity Detection (skip silence)
* Interactive terminal interface
* Fully offline after model download

---

## Requirements

* Python 3.8+
* Windows 10 / 11
* FFmpeg (required for audio extraction)

Optional:

* NVIDIA GPU with CUDA support (recommended for speed)

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/pavelzosim/VideoToText.Pro.git
cd VideoToText.Pro
```

### 2. Install Dependencies

CPU only:

```bash
pip install -r requirements.txt
```

GPU (Windows):

```bash
install_gpu.bat
```

### 3. Verify Installation

```bash
python check_installation.py
```

### 4. Run

```bash
run_transcription.bat
```

Or directly:

```bash
python transcribe_video.py
```

---

## Usage Overview

1. Place video files into the `video/` folder
2. Run the tool
3. Select options from the terminal menu
4. Transcriptions are saved to `output/`

Supported video formats include:
`mp4`, `mov`, `avi`, `mkv`, `webm`, `flv`, `wmv`, `m4v`

---

## Configuration

Main settings can be edited in `transcribe_video.py`:

```python
MODEL_SIZE = "medium"   # tiny / base / small / medium / large
LANGUAGE = None         # None = auto-detect
SAVE_SRT = False
BEAM_SIZE = 1
VAD_FILTER = True
```

Model size affects speed, accuracy, and VRAM usage.

---

## Folder Structure

```
VideoToText.Pro/
├── transcribe_video.py      # Main transcription logic
├── check_installation.py    # Dependency and GPU checks
├── run_transcription.bat    # Interactive launcher
├── install_gpu.bat          # GPU setup helper
├── requirements.txt
├── video/                   # Input video files
└── output/                  # Generated transcriptions
```

---

## Design Philosophy

* Reliable over flashy
* Predictable results
* Minimal user input
* Offline-first workflows
* Built as a tool, not a demo

---

Like this post? ( ´◔ ω◔`) ノシ

**Support:**
[Buy Me a Coffee](https://buymeacoffee.com/pavel.zosim) |
[Patreon](https://www.patreon.com/c/pavel_zosim) |
[GitHub](https://github.com/pavelzosim) |
[Gumroad](https://pavelzosim.gumroad.com/) |
[YouTube](https://www.youtube.com/@VFX_PavelZosim/videos)

```
