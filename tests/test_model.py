# tests/test_model.py
import joblib
import numpy as np

def test_model_exists():
    bundle = joblib.load("models/model.joblib")
    assert "model" in bundle

def test_prediction_shape():
    bundle = joblib.load("models/model.joblib")
    model = bundle["model"]
    x = np.zeros((1, 4))
    pred = model.predict(x)
    assert pred.shape == (1,)
