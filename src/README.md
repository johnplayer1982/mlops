# train.py

The train.py script trains and saves a machine learning model using the Iris dataset. Here’s what it does step by step:

- Loads the Iris dataset using scikit-learn.
- Splits the data into training and validation sets.
- Trains a RandomForestClassifier on the training data.
- Evaluates the model’s accuracy on the validation set.
- If a trained model already exists in models/model.joblib, it loads and reports its stored accuracy.
- If not, it trains a new model, prints the validation accuracy, and saves the model and accuracy to disk for future use.

This script automates the process of training and persisting a simple machine learning model.

# app.py

The app.py file creates a simple web API using FastAPI to serve predictions from the trained machine learning model. Here’s what it does:

- Loads the trained model from model.joblib at startup. If the model file is missing, it prints a warning and exits.
- Defines a POST endpoint /predict that accepts a JSON payload with a list of features.
- When a request is made to /predict, it uses the loaded model to predict the class for the provided features and returns the prediction as JSON.

In summary, app.py is an API server for making predictions with your trained model.

