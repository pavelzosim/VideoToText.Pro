@echo off
REM ================================================================
REM Video-to-Text Transcription Tool - Interactive Menu
REM 
REM Author: Pavel Zosim
REM GitHub: https://github.com/pavelzosim
REM LinkedIn: https://www.linkedin.com/in/pavelzosim
REM Website: https://www.pavelzosim.com
REM Version: 1.0.0
REM ================================================================

setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1
title Video Transcription Tool
color 0A

REM Initialize defaults on first run
if not defined MODEL_SIZE (
    set MODEL_SIZE=medium
    set LANGUAGE=None
    set LANG_DISPLAY=Auto-detect
    set SAVE_SRT=False
    set SRT_DISPLAY=OFF
    set SKIP_EXISTING=True
    set SKIP_DISPLAY=ON
    set VAD_FILTER=True
    set VAD_DISPLAY=ON
    set BEAM_SIZE=1
    set EXTRACT_AUDIO=True
    set AUDIO_DISPLAY=ON ^(faster^)
    set VAD_MIN_SILENCE_MS=500
    set VAD_SPEECH_PAD_MS=400
    set VAD_MIN_SPEECH_MS=250
    set AUDIO_RATE=16000
)

:MENU
cls
@echo ═══════════════════════════════════════════════════════════
@echo           🎙️  VIDEO TO TEXT TRANSCRIPTION TOOL
@echo ═══════════════════════════════════════════════════════════
@echo.
@echo  Current Settings:
@echo  ─────────────────────────────────────────────────────────
@echo   [1] Model Size      : %MODEL_SIZE% (tiny/base/small/medium/large^)
@echo   [2] Language        : %LANG_DISPLAY%
@echo   [3] Save SRT        : %SRT_DISPLAY%
@echo   [4] Skip Existing   : %SKIP_DISPLAY%
@echo   [5] VAD Filter      : %VAD_DISPLAY%
@echo   [6] Beam Size       : %BEAM_SIZE% (1=fast, 5=accurate^)
@echo   [7] Audio Extract   : %AUDIO_DISPLAY%
@echo  ─────────────────────────────────────────────────────────
@echo.
@echo   [A] 🔧 Advanced VAD Settings
@echo   [R] 🚀 RUN TRANSCRIPTION
@echo   [Q] ❌ Quit
@echo.
@echo ═══════════════════════════════════════════════════════════
@set /p choice="Select option: "

if /i "%choice%"=="1" goto CHOOSE_MODEL
if /i "%choice%"=="2" goto CHOOSE_LANG
if /i "%choice%"=="3" goto TOGGLE_SRT
if /i "%choice%"=="4" goto TOGGLE_SKIP
if /i "%choice%"=="5" goto TOGGLE_VAD
if /i "%choice%"=="6" goto CHOOSE_BEAM
if /i "%choice%"=="7" goto TOGGLE_AUDIO
if /i "%choice%"=="A" goto ADVANCED_VAD
if /i "%choice%"=="R" goto RUN
if /i "%choice%"=="Q" goto END
goto MENU

:CHOOSE_MODEL
cls
@echo ═══════════════════════════════════════════════════════════
@echo                    SELECT MODEL SIZE
@echo ═══════════════════════════════════════════════════════════
@echo.
@echo   [1] tiny   - Fastest, lowest quality (~1GB VRAM^)
@echo   [2] base   - Fast, decent quality (~1GB VRAM^)
@echo   [3] small  - Balanced (~2GB VRAM^)
@echo   [4] medium - Good quality (~5GB VRAM^) ⭐ Recommended
@echo   [5] large  - Best quality (~10GB VRAM^)
@echo.
@echo   [0] Back to menu
@echo.
@set /p model_choice="Select: "

if "%model_choice%"=="1" set MODEL_SIZE=tiny
if "%model_choice%"=="2" set MODEL_SIZE=base
if "%model_choice%"=="3" set MODEL_SIZE=small
if "%model_choice%"=="4" set MODEL_SIZE=medium
if "%model_choice%"=="5" set MODEL_SIZE=large
if "%model_choice%"=="0" goto MENU

goto MENU

:CHOOSE_LANG
cls
@echo ═══════════════════════════════════════════════════════════
@echo                    SELECT LANGUAGE
@echo ═══════════════════════════════════════════════════════════
@echo.
@echo   [1] Auto-detect (slower but universal^)
@echo   [2] English
@echo   [3] Russian
@echo   [4] Spanish
@echo   [5] French
@echo   [6] German
@echo   [7] Chinese
@echo   [8] Japanese
@echo   [9] Portuguese
@echo   [10] Italian
@echo.
@echo   [0] Back to menu
@echo.
@set /p lang_choice="Select: "

if "%lang_choice%"=="1" (
    set LANGUAGE=None
    set LANG_DISPLAY=Auto-detect
)
if "%lang_choice%"=="2" (
    set LANGUAGE="en"
    set LANG_DISPLAY=English
)
if "%lang_choice%"=="3" (
    set LANGUAGE="ru"
    set LANG_DISPLAY=Russian
)
if "%lang_choice%"=="4" (
    set LANGUAGE="es"
    set LANG_DISPLAY=Spanish
)
if "%lang_choice%"=="5" (
    set LANGUAGE="fr"
    set LANG_DISPLAY=French
)
if "%lang_choice%"=="6" (
    set LANGUAGE="de"
    set LANG_DISPLAY=German
)
if "%lang_choice%"=="7" (
    set LANGUAGE="zh"
    set LANG_DISPLAY=Chinese
)
if "%lang_choice%"=="8" (
    set LANGUAGE="ja"
    set LANG_DISPLAY=Japanese
)
if "%lang_choice%"=="9" (
    set LANGUAGE="pt"
    set LANG_DISPLAY=Portuguese
)
if "%lang_choice%"=="10" (
    set LANGUAGE="it"
    set LANG_DISPLAY=Italian
)
if "%lang_choice%"=="0" goto MENU

goto MENU

:TOGGLE_SRT
if "%SAVE_SRT%"=="True" (
    set SAVE_SRT=False
    set SRT_DISPLAY=OFF
) else (
    set SAVE_SRT=True
    set SRT_DISPLAY=ON
)
goto MENU

:TOGGLE_SKIP
if "%SKIP_EXISTING%"=="True" (
    set SKIP_EXISTING=False
    set SKIP_DISPLAY=OFF
) else (
    set SKIP_EXISTING=True
    set SKIP_DISPLAY=ON
)
goto MENU

:TOGGLE_VAD
if "%VAD_FILTER%"=="True" (
    set VAD_FILTER=False
    set VAD_DISPLAY=OFF
) else (
    set VAD_FILTER=True
    set VAD_DISPLAY=ON
)
goto MENU

:CHOOSE_BEAM
cls
@echo ═══════════════════════════════════════════════════════════
@echo                    SELECT BEAM SIZE
@echo ═══════════════════════════════════════════════════════════
@echo.
@echo   Beam size controls accuracy vs speed trade-off:
@echo.
@echo   [1] 1 - Fastest (greedy decoding^)
@echo   [2] 3 - Balanced
@echo   [3] 5 - Most accurate (slower^) ⭐ Recommended
@echo.
@echo   [0] Back to menu
@echo.
@set /p beam_choice="Select: "

if "%beam_choice%"=="1" set BEAM_SIZE=1
if "%beam_choice%"=="2" set BEAM_SIZE=3
if "%beam_choice%"=="3" set BEAM_SIZE=5
if "%beam_choice%"=="0" goto MENU

goto MENU

:TOGGLE_AUDIO
if "%EXTRACT_AUDIO%"=="True" (
    set EXTRACT_AUDIO=False
    set AUDIO_DISPLAY=OFF ^(slower^)
) else (
    set EXTRACT_AUDIO=True
    set AUDIO_DISPLAY=ON ^(faster^)
)
goto MENU

:ADVANCED_VAD
cls
@echo ═══════════════════════════════════════════════════════════
@echo                  ADVANCED VAD SETTINGS
@echo ═══════════════════════════════════════════════════════════
@echo.
@echo  Voice Activity Detection (VAD^) fine-tuning:
@echo  ─────────────────────────────────────────────────────────
@echo   Current values:
@echo   • Min Silence Duration : %VAD_MIN_SILENCE_MS% ms
@echo   • Speech Padding       : %VAD_SPEECH_PAD_MS% ms
@echo   • Min Speech Duration  : %VAD_MIN_SPEECH_MS% ms
@echo   • Sample Rate          : %AUDIO_RATE% Hz
@echo  ─────────────────────────────────────────────────────────
@echo.
@echo   [1] Reset to defaults (500/400/250/16000^)
@echo   [2] Aggressive (skip more silence: 300/200/200/16000^)
@echo   [3] Conservative (keep more audio: 800/600/300/16000^)
@echo   [4] High Quality Audio (44100 Hz sample rate^)
@echo   [5] Custom values...
@echo.
@echo   [0] Back to menu
@echo.
@set /p vad_choice="Select: "

if "%vad_choice%"=="1" (
    set VAD_MIN_SILENCE_MS=500
    set VAD_SPEECH_PAD_MS=400
    set VAD_MIN_SPEECH_MS=250
    set AUDIO_RATE=16000
)
if "%vad_choice%"=="2" (
    set VAD_MIN_SILENCE_MS=300
    set VAD_SPEECH_PAD_MS=200
    set VAD_MIN_SPEECH_MS=200
    set AUDIO_RATE=16000
)
if "%vad_choice%"=="3" (
    set VAD_MIN_SILENCE_MS=800
    set VAD_SPEECH_PAD_MS=600
    set VAD_MIN_SPEECH_MS=300
    set AUDIO_RATE=16000
)
if "%vad_choice%"=="4" (
    set AUDIO_RATE=44100
)
if "%vad_choice%"=="5" goto CUSTOM_VAD
if "%vad_choice%"=="0" goto MENU

goto MENU

:CUSTOM_VAD
@echo.
@echo Enter values (or press Enter to skip^):
@echo.
@set /p custom_silence="Min Silence Duration (ms^) [%VAD_MIN_SILENCE_MS%]: "
if not "%custom_silence%"=="" set VAD_MIN_SILENCE_MS=%custom_silence%

@set /p custom_pad="Speech Padding (ms^) [%VAD_SPEECH_PAD_MS%]: "
if not "%custom_pad%"=="" set VAD_SPEECH_PAD_MS=%custom_pad%

@set /p custom_speech="Min Speech Duration (ms^) [%VAD_MIN_SPEECH_MS%]: "
if not "%custom_speech%"=="" set VAD_MIN_SPEECH_MS=%custom_speech%

@set /p custom_rate="Sample Rate (Hz^) [%AUDIO_RATE%]: "
if not "%custom_rate%"=="" set AUDIO_RATE=%custom_rate%

goto MENU

:RUN
cls
@echo ═══════════════════════════════════════════════════════════
@echo                    STARTING TRANSCRIPTION
@echo ═══════════════════════════════════════════════════════════
@echo.

REM Create config file with all parameters
(
echo MODEL_SIZE = "%MODEL_SIZE%"
echo LANGUAGE = %LANGUAGE%
echo SAVE_SRT = %SAVE_SRT%
echo SKIP_EXISTING = %SKIP_EXISTING%
echo VAD_FILTER = %VAD_FILTER%
echo BEAM_SIZE = %BEAM_SIZE%
echo EXTRACT_AUDIO = %EXTRACT_AUDIO%
echo VAD_MIN_SILENCE_MS = %VAD_MIN_SILENCE_MS%
echo VAD_SPEECH_PAD_MS = %VAD_SPEECH_PAD_MS%
echo VAD_MIN_SPEECH_DURATION_MS = %VAD_MIN_SPEECH_MS%
echo AUDIO_SAMPLE_RATE = %AUDIO_RATE%
) > config_temp.py

REM Check if video folder exists
if not exist "video" (
    @echo ❌ Error: "video" folder not found!
    @echo Creating "video" folder...
    mkdir video
    @echo.
    @echo Please place your video files in the "video" folder and run again.
    pause
    goto MENU
)

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    @echo ❌ Error: Python is not installed or not in PATH
    @echo.
    @echo Please install Python 3.8+ from https://www.python.org/
    pause
    goto END
)

REM Check required packages
@echo Checking dependencies...
python -c "import torch; import faster_whisper; import tqdm" >nul 2>&1
if errorlevel 1 (
    @echo.
    @echo ⚠️  Missing required packages. Installing...
    @echo.
    pip install torch faster-whisper tqdm
    @echo.
)

REM Run the script
python transcribe_video.py

REM Cleanup
if exist config_temp.py del config_temp.py

@echo.
@echo ═══════════════════════════════════════════════════════════
pause
goto MENU

:END
cls
@echo.
@echo Thank you for using Video Transcription Tool!
@echo.
timeout /t 2 >nul
exit