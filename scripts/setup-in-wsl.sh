#!/usr/bin/env bash
set -euo pipefail
# Intended for Ubuntu 22.04 under WSL2 with RTX 3060 visible through nvidia-smi.
# No existing Windows AI environments are modified.
if ! command -v nvidia-smi >/dev/null 2>&1; then
  echo 'NVIDIA GPU not visible in WSL. Check WSL2/NVIDIA setup first.' >&2
  exit 1
fi
sudo apt-get update
sudo apt-get install -y git python3.10 python3.10-venv python3-pip ffmpeg build-essential
mkdir -p "$HOME/AI"
if [ ! -d "$HOME/AI/SongGeneration/.git" ]; then
  git clone https://github.com/levo-demo/LeVo.git "$HOME/AI/SongGeneration"
fi
cd "$HOME/AI/SongGeneration"
python3.10 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip wheel setuptools
# CUDA wheel family is isolated to this virtual environment.
python -m pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu126
python -m pip install -r requirements.txt
python -m pip install --no-deps -r requirements_nodeps.txt
python - <<'PY'
import torch
print('PyTorch:', torch.__version__)
print('CUDA available:', torch.cuda.is_available())
print('GPU:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'Not detected')
if not torch.cuda.is_available():
    raise SystemExit('CUDA not available; do not download model weights yet.')
PY
printf '\nEnvironment installed. Model weights are NOT downloaded. See README.md for next steps.\n'
