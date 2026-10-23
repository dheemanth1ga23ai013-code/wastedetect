# WasteDetect AI

Drag & drop street photos -> litter detection (zero-shot YOLO-World via ONNX Runtime), 0-100 severity
score, cleanup priority and a downloadable report. Runs in under 512 MB RAM (no PyTorch at runtime).

## Deploy on Render (free, native Python)
1. Push this folder to GitHub.
2. Render > New > Blueprint > pick the repo > Apply (reads `render.yaml`).
   Manual setup: Web Service, Language Python 3, Build Command `bash build.sh`,
   Start Command `streamlit run app.py --server.port=$PORT --server.address=0.0.0.0 --server.headless=true --server.enableCORS=false --server.enableXsrfProtection=false --server.fileWatcherType=none --server.maxUploadSize=10 --browser.gatherUsageStats=false`,
   health check `/_stcore/health`, env `PYTHON_VERSION=3.11.9`.
3. `build.sh` exports the ONNX model on first build (~10 min). To skip that, run
   `pip install -r requirements-export.txt && python export_onnx.py` yourself and commit `models/waste_world.onnx`.

Docker alternative: `render.docker.yaml` (rename to `render.yaml`) + `Dockerfile`.

## Local
```bash
pip install -r requirements.txt && pip install -r requirements-export.txt && python export_onnx.py
streamlit run app.py
```

## Score
`100 * (0.6*min(1, weighted_items/15) + 0.4*min(1, coverage/0.25))`; Low <25, Moderate <50, High <75, Critical >=75.
