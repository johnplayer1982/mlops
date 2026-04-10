# app.py
from fastapi import FastAPI
import joblib
import numpy as np
from pydantic import BaseModel
import os
import sys

class Request(BaseModel):
    features: list


app = FastAPI()

# Check for model file existence at startup and exit with a warning if missing
model_path = "models/model.joblib"
if not os.path.exists(model_path):
    print(f"WARNING: model file not found: {model_path}, please run `python src/train.py` to train and save the model before starting the app.")
    sys.exit(1)

model_bundle = joblib.load(model_path)
model = model_bundle["model"]

@app.post("/predict")
def predict(req: Request):
    x = np.array(req.features).reshape(1, -1)
    pred = model.predict(x).tolist()
    return {"prediction": pred}
