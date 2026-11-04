# SongGeneration — GitHub Actions preparation

This is an experimental, **CPU-only** Linux dependency check for Tencent LeVo / SongGeneration plus a WSL2 setup script. It does not generate music, build a Windows .exe, or include large model weights. It leaves ACE-Step, DiffRhythm, and SaraMusic untouched.

## GitHub usage
1. Create a new GitHub repository (for example, `SongGeneration-Build`).
2. Add `.github/workflows/songgeneration-prepare.yml`, `scripts/setup-in-wsl.sh`, and this README at their exact paths. Do not upload the ZIP unchanged as a single file: GitHub must see the workflow YAML in `.github/workflows/`.
3. Go to **Actions** → **SongGeneration Linux dependency check** → **Run workflow**.
4. On completion, download the `songgeneration-linux-check-and-local-kit` artifact (reports + local script). If the run fails, inspect the failed step; artifacts are still attempted.

The workflow runs on a standard Ubuntu **CPU** runner (no NVIDIA GPU), and installs CPU builds of PyTorch for dependency checking. It intentionally does NOT download models or a GPU-ready virtual environment. It is capped at 90 minutes (actual elapsed time may be shorter), and uses GitHub Actions quota according to your account plan.

## Local WSL2 follow-up (separate from the GitHub run)
Once WSL2 Ubuntu is installed and `nvidia-smi` shows the GPU *inside Ubuntu*, run the setup script there. You can copy `scripts/setup-in-wsl.sh` into your Ubuntu home directory, then run `bash setup-in-wsl.sh`. It installs CUDA PyTorch 2.6.0 in `~/AI/SongGeneration/.venv`, not in any Windows Python environment. It does not download model weights.

## Model checkpoint download (later)
The official source README currently uses two Hugging Face downloads: `lglg666/SongGeneration-Runtime` and `lglg666/SongGeneration-base-new`. The base-new checkpoint is described by its developers as requiring about 10 GB VRAM without reference audio. After CUDA succeeds locally and sufficient disk space is available, follow the official source instructions for downloads and `sh generate.sh ... --low_mem --not_use_flash_attn --bgm`.

Official repository: https://github.com/levo-demo/LeVo

## Why this is not a prebuilt engine
A CPU GitHub runner cannot validate CUDA generation, and an Ubuntu Python environment created on GitHub does not automatically run as a native Windows binary. The useful artifact is a repeatable dependency check and a validated-for-syntax local setup kit, not a guaranteed working music model. The local GPU test still has to happen on your machine.
