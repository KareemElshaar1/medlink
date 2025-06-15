# MedLink ML Service

This ML service provides drug dosage classification based on the MIMIC-III dataset.

## Setup

1. Download the MIMIC-III dataset from [Kaggle](https://www.kaggle.com/datasets/asjad99/mimiciii?resource=download)
2. Install the required Python packages:
   ```
   pip install -r requirements.txt
   ```

## Training the model

1. Run the training script:
   ```
   python train_model.py
   ```
2. When prompted, provide the path to the MIMIC-III dataset

## Running the API server

1. After training, run the API server:
   ```
   python api.py
   ```
2. The API will be available at http://localhost:8000

## API Documentation

- GET /: Check if the API is running
- GET /health: Check if the model is loaded
- POST /predict: Get a dosage prediction based on patient data

Example request for /predict:
```json
{
  "age": 65,
  "drug": "Aspirin",
  "route": "Oral",
  "gender": "M",
  "admission_type": "EMERGENCY"
}
``` 