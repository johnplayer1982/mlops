# MLOps Learning

A repo designed to help me with the transition from DevOps to MLOps.  This is a safe area to make mistakes, misunderstand concepts and ultimately learn.

# Setup

## Python Setup

- Create python virtual env ``python -m venv .venv``
- Initialise venv ``.venv\Scripts\activate``
- Install packages ``pip install -r requirements.txt``

## Precommit Setup (Secret scanning)

- Install precommit with ``pre-commit install`` for pre-commit secrets scanning

## Create Azure Infra

Create the storge account for tfstate:

Powershell:
```
.\scripts\create-tf-backend.ps1
```

You'll need the output:
```
Storage Account: mytfstate6692
Container: tfstate
Resource Group: my-tfstate-rg
```

The ACR (Azure Container Registry) and ACA (Azure Container App) are created via terraform (/.terraform/) to run (make sure terraform is installed):

- cd into the terraform dir ``cd .terraform``
- Initialise backend ``terraform init``
- Plan ``terraform plan -out tfplan``
- Apply ``terraform apply tfplan``

Notes:  
The ACA has a placeholder default image:

```
container {
  name   = var.aca_name
  image  = "placeholder"
  cpu    = 0.5
  memory = "1.0Gi"
}
```

As an image wont exist when the infrastructure is created, this will be updated during the CI workflow.  

TODO - Create 3 secrets in GitHub:

1. ACR_PASSWORD
2. ACR_LOGIN_SERVER
3. ACR_USERNAME


# Running

## Local Machine

- Run ``python src/train.py`` to train the model, creating model.joblib in /models/
- Run ``uvicorn src.app:app --host 0.0.0.0 --port 8080 --reload`` to serve a prediction API using FastAPI that returns model predictions.

## Docker

- If no jobfile exists, run training ``python src/train.py``
- Then run docker:

```
docker build -t my-ml-app:latest .
docker run --rm -p 8080:8080 my-ml-app:latest
```

## Smoke Test

```
curl -sS -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"features":[5.1,3.5,1.4,0.2]}'
```

Should return a rediction ``{"prediction":[0]}``

# What everything is

## src/train.py

### Summary

Loads the [Iris dataset](https://scikit-learn.org/1.4/auto_examples/datasets/plot_iris_dataset.html), trains a RandomForest, prints validation accuracy and saves the trained model (/model.joblib).

### High level

Checks MODEL_PATH ("models/model.joblib"); if the file exists it loads a dict from disk, extracts model and optional acc, prints that it loaded the model (and stored accuracy if present). If the file doesn't exist it loads the Iris dataset, trains a RandomForestClassifier (prints "Training model..." while training), computes validation accuracy, prints it, and saves {"model": model, "acc": acc} to MODEL_PATH.

### Jobfiles

A .joblib file is a generated Python object created using the joblib library. Used to store trained models, preprocessing pipelines, or large data objects so they can be reused without retraining.

The first time you run ``python src/train.py`` it will take a few mins (hardware depending), but subsequents runs are much faster as the saved joblib file is loaded rather than retraining.

## src/app.py

### Summary

Service a prediction API using FastAPI.  Loads ``models/model.joblib`` at import time and extracts model from the saved bundle (#12)

### Endpoint

Endpoint ``/predict`` calls model.predict (#15) and returns ``{"prediction": [...]}`` list.  Example use:

```
curl -sS -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"features":[5.1,3.5,1.4,0.2]}'
```

Returns: ``{"prediction":[0]}`` (Is this the correct result?)
