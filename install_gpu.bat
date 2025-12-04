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
chcp 65001 >nul
title Install GPU Dependencies (CUDA 12.x/13.x)
color 0A

echo ================================================================
echo      VIDEO TO TEXT - GPU INSTALLATION (CUDA 12.x/13.x)
echo ================================================================
echo.
echo Detected GPU: NVIDIA GeForce RTX 4060 Laptop
echo CUDA Version: 13.0
echo.
echo This will install:
echo   - PyTorch with CUDA 12.1 support
echo   - CTranslate2 GPU backend
echo   - faster-whisper
echo   - Additional dependencies
echo.
echo ================================================================
pause

echo.
echo [1/4] Installing PyTorch with CUDA 12.1...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

echo.
echo [2/4] Installing CTranslate2 GPU backend...
pip install ctranslate2

echo.
echo [3/4] Installing faster-whisper...
pip install faster-whisper

echo.
echo [4/4] Installing additional dependencies...
pip install tqdm numpy

echo.
echo ================================================================
echo Installation complete!
echo ================================================================
echo.
echo Next step: Run check_installation.py to verify
echo Command: python check_installation.py
echo.
pause