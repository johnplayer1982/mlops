# train.py
import os
import joblib
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

# Where to save the models
MODEL_PATH = "models/model.joblib"

def load_data():
    data = load_iris()
    return data.data, data.target

def train_model(X, y):
    print("Training model...")  # <-- helps you see when it actually trains
    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.2, random_state=42
    )
    model = RandomForestClassifier(n_estimators=50, random_state=42)
    model.fit(X_train, y_train)
    preds = model.predict(X_val)
    acc = accuracy_score(y_val, preds)
    return model, acc

if __name__ == "__main__":
    if os.path.exists(MODEL_PATH):
        data = joblib.load(MODEL_PATH)
        model = data["model"]
        acc = data.get("acc", None)

        print("Loaded model from disk")
        if acc is not None:
            print(f"Stored validation accuracy: {acc:.4f}")
    else:
        X, y = load_data()
        model, acc = train_model(X, y)
        print(f"Validation accuracy: {acc:.4f}")

        # Make sure models directory exists before saving
        os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)

        joblib.dump({"model": model, "acc": acc}, MODEL_PATH)
        print("Model saved to disk")
