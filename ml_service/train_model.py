import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, accuracy_score
import joblib
import os

# Path to the MIMIC-III dataset
# Note: User needs to download this dataset from Kaggle: 
# https://www.kaggle.com/datasets/asjad99/mimiciii

def load_and_preprocess_data(data_path):
    # Load prescriptions data
    prescriptions = pd.read_csv(os.path.join(data_path, 'PRESCRIPTIONS.csv'))
    
    # Load patients data
    patients = pd.read_csv(os.path.join(data_path, 'PATIENTS.csv'))
    
    # Load admissions data
    admissions = pd.read_csv(os.path.join(data_path, 'ADMISSIONS.csv'))
    
    # Merge datasets
    df = prescriptions.merge(patients, on='SUBJECT_ID', how='left')
    df = df.merge(admissions, on=['SUBJECT_ID', 'HADM_ID'], how='left')
    
    # Select relevant features
    features = df[['SUBJECT_ID', 'HADM_ID', 'DRUG', 'DOSE_VAL_RX', 'DOSE_UNIT_RX', 
                  'ROUTE', 'GENDER', 'AGE', 'ADMISSION_TYPE', 'DIAGNOSIS']]
    
    # Clean up data
    features = features.dropna()
    
    # Convert age to numeric
    features['AGE'] = pd.to_numeric(features['AGE'], errors='coerce')
    features = features.dropna(subset=['AGE'])
    
    # Create categorical features
    le_drug = LabelEncoder()
    le_route = LabelEncoder()
    le_gender = LabelEncoder()
    le_admission = LabelEncoder()
    
    features['DRUG_CODE'] = le_drug.fit_transform(features['DRUG'])
    features['ROUTE_CODE'] = le_route.fit_transform(features['ROUTE'])
    features['GENDER_CODE'] = le_gender.fit_transform(features['GENDER'])
    features['ADMISSION_CODE'] = le_admission.fit_transform(features['ADMISSION_TYPE'])
    
    # Create dosage classes based on percentiles
    dosage_thresholds = features['DOSE_VAL_RX'].quantile([0.25, 0.5, 0.75]).values
    
    def classify_dosage(val):
        if val <= dosage_thresholds[0]:
            return 0  # Low dose
        elif val <= dosage_thresholds[1]:
            return 1  # Medium-low dose
        elif val <= dosage_thresholds[2]:
            return 2  # Medium-high dose
        else:
            return 3  # High dose
    
    features['DOSAGE_CLASS'] = features['DOSE_VAL_RX'].apply(classify_dosage)
    
    # Select final features for training
    X = features[['AGE', 'DRUG_CODE', 'ROUTE_CODE', 'GENDER_CODE', 'ADMISSION_CODE']]
    y = features['DOSAGE_CLASS']
    
    # Store encoders for later use
    encoders = {
        'drug': le_drug,
        'route': le_route,
        'gender': le_gender,
        'admission': le_admission,
        'dosage_thresholds': dosage_thresholds
    }
    
    return X, y, encoders

def train_model(X, y):
    # Split data into train and test sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Create pipeline with preprocessing and model
    pipeline = Pipeline([
        ('scaler', StandardScaler()),
        ('classifier', RandomForestClassifier(n_estimators=100, random_state=42))
    ])
    
    # Train the model
    pipeline.fit(X_train, y_train)
    
    # Evaluate the model
    y_pred = pipeline.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    
    print(f"Model Accuracy: {accuracy:.4f}")
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred))
    
    return pipeline

def main():
    print("Starting model training...")
    data_path = input("Enter the path to the MIMIC-III dataset: ")
    
    try:
        X, y, encoders = load_and_preprocess_data(data_path)
        model = train_model(X, y)
        
        # Save the model and encoders
        joblib.dump(model, 'E:\k\ml_service\dosage_model.pkl')
        joblib.dump(encoders, 'encoders.pkl')
        
        print("Model and encoders saved successfully!")
    except Exception as e:
        print(f"Error during training: {str(e)}")

if __name__ == "__main__":
    main() 