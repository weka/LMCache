# Installing lmcache from source

Tested on: Ubuntu (aarch64), NVIDIA GB10, CUDA 13.x, Python 3.12 venv.

## Prerequisites

### 1. Python dev headers

The venv needs Python C headers to compile CUDA extensions:

```bash
sudo apt-get install -y python3.12-dev libpython3.12-dev
```

### 2. CUDA-enabled PyTorch

The default PyPI torch is CPU-only, which breaks the build regardless of `CUDA_HOME`.
Replace it with a CUDA-enabled build matching your system's CUDA major version.

Check your CUDA version:
```bash
nvcc --version   # or: nvidia-smi
```

Install the matching torch. For CUDA 13.x:
```bash
pip install --force-reinstall torch==2.9.1+cu130 \
    --index-url https://download.pytorch.org/whl/cu130
```

For other CUDA versions, replace `cu130` with the appropriate tag
(e.g. `cu128` for CUDA 12.8, `cu126` for 12.6). Available builds:
```bash
pip index versions torch --index-url https://download.pytorch.org/whl/cu130
```

### 3. Fix setuptools (the torch install downgrades it)

```bash
pip install "setuptools>=77.0.3,<81.0.0"
```

## Install lmcache

Use `--no-build-isolation` so the build uses the already-installed CUDA torch
(as recommended in `pyproject.toml`):

```bash
pip install --no-build-isolation -e /path/to/lmcache
```

## Verify

```bash
python -c "import torch; import lmcache; import lmcache.c_ops; print('OK')"
```

Note: always import `torch` before `lmcache.c_ops` — torch sets up the shared
library paths (`libc10.so` etc.) that the extension depends on. Normal usage
patterns already do this.
