#!/usr/bin/env python3
"""
Installation verification script.
Checks if GPU and all dependencies are properly configured.
"""

import sys

def check_pytorch():
    """Check PyTorch installation and CUDA support"""
    try:
        import torch
        print("✅ PyTorch installed:", torch.__version__)
        
        cuda_available = torch.cuda.is_available()
        print(f"   CUDA available: {cuda_available}")
        
        if cuda_available:
            print(f"   CUDA version: {torch.version.cuda}")
            print(f"   GPU: {torch.cuda.get_device_name(0)}")
            print(f"   GPU count: {torch.cuda.device_count()}")
            print(f"   GPU memory: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB")
        else:
            print("   ⚠️  GPU not detected - will use CPU")
        
        return True
    except ImportError:
        print("❌ PyTorch not installed")
        return False

def check_ctranslate2():
    """Check CTranslate2 installation"""
    try:
        import ctranslate2
        print(f"✅ CTranslate2 installed: {ctranslate2.__version__}")
        
        # Check if GPU backend is available
        try:
            devices = ctranslate2.get_supported_compute_types("cuda")
            if devices:
                print(f"   GPU compute types: {devices}")
            else:
                print("   ⚠️  No GPU compute types available")
        except:
            print("   ⚠️  GPU backend not available")
        
        return True
    except ImportError:
        print("❌ CTranslate2 not installed")
        return False

def check_faster_whisper():
    """Check faster-whisper installation"""
    try:
        import faster_whisper
        print(f"✅ faster-whisper installed")
        
        # Try to load a tiny model on GPU
        try:
            from faster_whisper import WhisperModel
            print("   Testing GPU model loading...")
            
            import torch
            if torch.cuda.is_available():
                model = WhisperModel("tiny", device="cuda", compute_type="float16")
                print("   ✅ GPU model loading works!")
                del model
            else:
                model = WhisperModel("tiny", device="cpu")
                print("   ✅ CPU model loading works")
                del model
        except Exception as e:
            print(f"   ⚠️  Model loading failed: {e}")
        
        return True
    except ImportError:
        print("❌ faster-whisper not installed")
        return False

def check_other_deps():
    """Check other dependencies"""
    deps = {
        'tqdm': 'Progress bars',
        'numpy': 'Numerical operations',
    }
    
    all_ok = True
    for module, desc in deps.items():
        try:
            __import__(module)
            print(f"✅ {module} installed ({desc})")
        except ImportError:
            print(f"❌ {module} not installed ({desc})")
            all_ok = False
    
    return all_ok

def check_ffmpeg():
    """Check if ffmpeg is available"""
    import subprocess
    try:
        result = subprocess.run(['ffmpeg', '-version'], 
                              stdout=subprocess.DEVNULL, 
                              stderr=subprocess.DEVNULL)
        print("✅ FFmpeg installed")
        return True
    except FileNotFoundError:
        print("⚠️  FFmpeg not found (optional, but recommended)")
        print("   Download from: https://www.gyan.dev/ffmpeg/builds/")
        return False

def main():
    print("=" * 70)
    print("🔍 INSTALLATION VERIFICATION")
    print("=" * 70)
    print()
    
    results = []
    
    print("📦 Checking Python packages:")
    print("-" * 70)
    results.append(check_pytorch())
    results.append(check_ctranslate2())
    results.append(check_faster_whisper())
    results.append(check_other_deps())
    
    print()
    print("🔧 Checking external tools:")
    print("-" * 70)
    ffmpeg_ok = check_ffmpeg()
    
    print()
    print("=" * 70)
    
    if all(results):
        print("✅ ALL CORE CHECKS PASSED!")
        if ffmpeg_ok:
            print("   You're fully ready to transcribe videos!")
        else:
            print("   Install FFmpeg for faster processing")
    else:
        print("❌ SOME CHECKS FAILED")
        print("   Please install missing dependencies")
        print()
        print("Recommendations:")
        print("   - Run: install_gpu.bat")
        print("   - Or manually: pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121")
    
    print("=" * 70)
    input("\nPress Enter to exit...")

if __name__ == "__main__":
    main()