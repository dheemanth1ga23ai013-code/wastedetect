#!/usr/bin/env bash
# Render build step: install the light runtime, and (if the model isn't committed) export it
# to ONNX in a throwaway virtualenv so PyTorch never touches the runtime environment.
set -euo pipefail

pip install --upgrade pip
pip install -r requirements.txt

if [ ! -f models/waste_world.onnx ]; then
  echo ">> models/waste_world.onnx not found: exporting (one-time, ~5-10 min)"
  python -m venv /tmp/exportenv
  /tmp/exportenv/bin/pip install --upgrade pip
  /tmp/exportenv/bin/pip install -r requirements-export.txt
  # ultralytics pulls full OpenCV which needs libGL; swap for the headless build
  /tmp/exportenv/bin/pip uninstall -y opencv-python
  /tmp/exportenv/bin/pip install --force-reinstall --no-deps "opencv-python-headless<4.12"
  /tmp/exportenv/bin/python export_onnx.py
  rm -rf /tmp/exportenv
else
  echo ">> using committed models/waste_world.onnx"
fi

ls -lh models
