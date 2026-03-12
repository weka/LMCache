#!/usr/bin/env bash
# cibw_before_build.sh — run by cibuildwheel inside the manylinux container
# before each wheel build.
#
# IMPORTANT: PyPI torch is CPU-only and lacks CUDA extension headers.
# Install torch from PyTorch's own CUDA wheel index so that the CUDA-enabled
# headers (including c10/cuda/impl/cuda_cmake_macros.h) are present.
#
# Pre-install all build dependencies so the subsequent
# "pip wheel --no-build-isolation" step can run setup.py directly without
# creating an isolated venv.

set -euo pipefail

pip install ninja 'packaging>=24.2' 'setuptools>=77.0.3,<81.0.0' 'setuptools_scm>=8' wheel

# Install CUDA-enabled torch from PyTorch's wheel index (not PyPI CPU build).
# cu128 = CUDA 12.8. torch 2.8.0 is not published for cu128; use 2.7.1 which
# is ABI-compatible and includes the CUDA extension headers we need.
pip install 'torch==2.7.1+cu128' --index-url https://download.pytorch.org/whl/cu128
