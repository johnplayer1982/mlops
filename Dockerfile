# Dockerfile
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Install system deps if needed, then Python deps
COPY requirements.txt /app/requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
  && pip install --no-cache-dir -r /app/requirements.txt \
  && apt-get purge -y --auto-remove build-essential \
  && rm -rf /var/lib/apt/lists/*

# Copy source code (keep src at /app/src)
COPY . /app
# ensure model is copied into /app/model.joblib
RUN cp /app/models/model.joblib /app/model.joblib

# Create non-root user for production
RUN groupadd -r appuser && useradd -r -g appuser appuser \
  && chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

# Start Uvicorn pointing at the module path
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8080", "--workers", "4"]
