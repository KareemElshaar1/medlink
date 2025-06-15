import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, GridSearchCV, StratifiedKFold
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder, OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.metrics import classification_report, accuracy_score, confusion_matrix
from sklearn.svm import SVC
import xgboost as xgb
import matplotlib.pyplot as plt
import seaborn as sns
import joblib
import os
import time
from sklearn.feature_selection import SelectFromModel
from imblearn.over_sampling import SMOTE
from sklearn.ensemble import VotingClassifier

# تكوين النموذج المتقدم
print("=== MedLink Advanced Dosage Classification Model ===")
print("Creating synthetic dataset for training...")

# عدد العينات - زيادة كبيرة في حجم البيانات التدريبية
n_samples = 50000
np.random.seed(42)

# قائمة الأدوية مع تركيزاتها النموذجية
drugs_with_typical_doses = {
    'Aspirin': {'min': 75, 'max': 1000, 'unit': 'mg', 'age_factor': True},
    'Ibuprofen': {'min': 200, 'max': 800, 'unit': 'mg', 'age_factor': True},
    'Paracetamol': {'min': 500, 'max': 1000, 'unit': 'mg', 'age_factor': True},
    'Amoxicillin': {'min': 250, 'max': 1000, 'unit': 'mg', 'age_factor': True},
    'Omeprazole': {'min': 10, 'max': 40, 'unit': 'mg', 'age_factor': False},
    'Atorvastatin': {'min': 10, 'max': 80, 'unit': 'mg', 'age_factor': True},
    'Simvastatin': {'min': 5, 'max': 40, 'unit': 'mg', 'age_factor': True},
    'Metformin': {'min': 500, 'max': 2000, 'unit': 'mg', 'age_factor': False},
    'Lisinopril': {'min': 5, 'max': 40, 'unit': 'mg', 'age_factor': True},
    'Amlodipine': {'min': 2.5, 'max': 10, 'unit': 'mg', 'age_factor': True},
    'Warfarin': {'min': 1, 'max': 10, 'unit': 'mg', 'age_factor': True},
    'Levothyroxine': {'min': 25, 'max': 200, 'unit': 'mcg', 'age_factor': True},
    'Sertraline': {'min': 25, 'max': 200, 'unit': 'mg', 'age_factor': True},
    'Fluoxetine': {'min': 10, 'max': 60, 'unit': 'mg', 'age_factor': True},
    'Diazepam': {'min': 2, 'max': 10, 'unit': 'mg', 'age_factor': True},
    'Tramadol': {'min': 50, 'max': 400, 'unit': 'mg', 'age_factor': True},
    'Morphine': {'min': 5, 'max': 30, 'unit': 'mg', 'age_factor': True},
    'Losartan': {'min': 25, 'max': 100, 'unit': 'mg', 'age_factor': False},
    'Citalopram': {'min': 10, 'max': 40, 'unit': 'mg', 'age_factor': True},
    'Gabapentin': {'min': 300, 'max': 3600, 'unit': 'mg', 'age_factor': False}
}

# قوائم خيارات البيانات
drugs = list(drugs_with_typical_doses.keys())
routes = ['Oral', 'IV', 'Topical', 'Nasal', 'Rectal', 'Subcutaneous', 'Intramuscular']
routes_risk = {'Oral': 1, 'Topical': 0, 'Nasal': 1, 'Rectal': 1, 'IV': 3, 'Intramuscular': 2, 'Subcutaneous': 2}
genders = ['M', 'F']
admission_types = ['EMERGENCY', 'ELECTIVE', 'URGENT', 'NEWBORN', 'OTHER']
diagnoses = ['Hypertension', 'Diabetes', 'Pneumonia', 'Asthma', 'COPD', 'Heart Failure', 
             'Stroke', 'Cancer', 'Arthritis', 'Depression', 'Anxiety', 'Infection', 
             'Fracture', 'Renal Failure', 'Liver Disease', 'Thyroid Disorder']

# تصنيف خطورة التشخيصات
diagnosis_severity = {
    'Hypertension': 2, 'Diabetes': 2, 'Pneumonia': 3, 'Asthma': 2, 
    'COPD': 3, 'Heart Failure': 4, 'Stroke': 4, 'Cancer': 4, 
    'Arthritis': 1, 'Depression': 1, 'Anxiety': 1, 'Infection': 2,
    'Fracture': 2, 'Renal Failure': 4, 'Liver Disease': 4, 'Thyroid Disorder': 2
}

weights = np.random.normal(70, 15, n_samples)  # Mean 70kg, SD 15kg

# إنشاء البيانات
print("Generating realistic drug dosage data...")

# اختيار عشوائي للأدوية
selected_drugs = np.random.choice(drugs, n_samples)

# إنشاء أعمار واقعية مع توزيع مناسب
ages = np.concatenate([
    np.random.uniform(1, 18, int(n_samples * 0.15)),  # 15% أطفال
    np.random.uniform(18, 65, int(n_samples * 0.6)),  # 60% بالغين
    np.random.uniform(65, 90, n_samples - int(n_samples * 0.15) - int(n_samples * 0.6))  # 25% مسنين
])
np.random.shuffle(ages)

# إنشاء الجرعات بناءً على نطاق الدواء المختار
doses = []
dose_units = []
for i, drug in enumerate(selected_drugs):
    drug_info = drugs_with_typical_doses[drug]
    min_dose = drug_info['min']
    max_dose = drug_info['max']
    unit = drug_info['unit']
    age = ages[i]
    
    # استخدام توزيع لوغاريتمي للجرعات لتمثيل النطاقات الواقعية
    base_dose = np.random.uniform(min_dose, max_dose)
    
    # تعديل الجرعة استنادًا إلى وزن المريض
    weight_factor = weights[i] / 70  # نسبة الوزن إلى الوزن المعياري
    
    # تعديل حسب العمر إذا كان الدواء يتأثر بالعمر
    age_adjustment = 1.0
    if drug_info['age_factor']:
        if age < 18:
            age_adjustment = age / 18 * 0.7 + 0.3  # الأطفال يحصلون على جرعة أقل
        elif age > 65:
            age_adjustment = 1 - ((age - 65) / 25) * 0.3  # كبار السن يحصلون على جرعة أقل تدريجياً
    
    # الجرعة النهائية
    dose = base_dose * weight_factor * age_adjustment

    doses.append(dose)
    dose_units.append(unit)

# إنشاء ميزات إضافية
selected_routes = np.random.choice(routes, n_samples)
selected_genders = np.random.choice(genders, n_samples)
selected_admissions = np.random.choice(admission_types, n_samples)
selected_diagnoses = np.random.choice(diagnoses, n_samples)

# إنشاء ميزة طريقة الإعطاء المشفرة (درجة الخطورة)
route_risk_values = [routes_risk[route] for route in selected_routes]

# إنشاء ميزة خطورة التشخيص
diagnosis_risk_values = [diagnosis_severity[diag] for diag in selected_diagnoses]

# إضافة ميزة مؤشر كتلة الجسم BMI
bmi_values = weights / ((ages/100) ** 2)  # تقريب بسيط للطول بناءً على العمر

# إنشاء البيانات الأساسية
data = {
    'age': ages,
    'weight': weights,
    'drug': selected_drugs,
    'dose_val_rx': doses,
    'dose_unit_rx': dose_units,
    'route': selected_routes,
    'gender': selected_genders,
    'admission_type': selected_admissions,
    'diagnosis': selected_diagnoses,
    'route_risk': route_risk_values,
    'diagnosis_risk': diagnosis_risk_values,
    'bmi': bmi_values
}

# تحويل البيانات إلى DataFrame
df = pd.DataFrame(data)

# إضافة ميزات تعتمد على الارتباط بين البيانات
# إضافة عامل تعديل الجرعة للحالات الطارئة
mask_emergency = df['admission_type'] == 'EMERGENCY'
df.loc[mask_emergency, 'dose_val_rx'] = df.loc[mask_emergency, 'dose_val_rx'] * np.random.uniform(1.0, 1.5, mask_emergency.sum())

# تعديل الجرعة للأطفال
mask_children = df['age'] < 18
df.loc[mask_children, 'dose_val_rx'] = df.loc[mask_children, 'dose_val_rx'] * (df.loc[mask_children, 'age'] / 18)

# إضافة ميزة تفاعل بين خطورة التشخيص وطريقة الإعطاء
df['risk_interaction'] = df['route_risk'] * df['diagnosis_risk']

# إضافة ميزات لحالة المريض
df['age_group'] = pd.cut(df['age'], bins=[0, 2, 12, 18, 65, 80, 100], 
                        labels=[0, 1, 2, 3, 4, 5])  # تصنيف العمر إلى فئات
df['weight_group'] = pd.cut(df['weight'], bins=[0, 20, 40, 70, 100, 150, 200], 
                           labels=[0, 1, 2, 3, 4, 5])  # تصنيف الوزن إلى فئات

# إنشاء فئات للجرعات استنادًا إلى النسبة المئوية من الجرعة القصوى للدواء المعني
df['max_dose'] = df.apply(lambda row: drugs_with_typical_doses[row['drug']]['max'], axis=1)
df['dose_percentage'] = df['dose_val_rx'] / df['max_dose'] * 100

def classify_dosage(row):
    """تصنيف الجرعة باستخدام نموذج أكثر تعقيدًا"""
    # ميزات أساسية
    percentage = row['dose_percentage']
    age = row['age']
    is_emergency = row['admission_type'] == 'EMERGENCY'
    route_risk = row['route_risk']
    diagnosis_risk = row['diagnosis_risk']
    risk_interaction = row['risk_interaction']
    
    # الدواء وتأثيره بالعمر
    drug_info = drugs_with_typical_doses[row['drug']]
    age_sensitive = drug_info['age_factor']
    
    # تصنيف أساسي حسب النسبة المئوية
    if percentage <= 25:
        base_class = 0  # جرعة منخفضة
    elif percentage <= 50:
        base_class = 1  # جرعة متوسطة-منخفضة
    elif percentage <= 75:
        base_class = 2  # جرعة متوسطة-مرتفعة
    else:
        base_class = 3  # جرعة مرتفعة
    
    # تعديلات حسب العمر
    age_factor = 0
    if age_sensitive:
        if age < 12 and base_class > 0:
            age_factor = 1  # زيادة خطورة للأطفال
        elif age > 70 and base_class > 0:
            age_factor = 1  # زيادة خطورة لكبار السن
    
    # تعديلات حسب الحالة الطارئة
    emergency_factor = -1 if is_emergency and base_class < 3 else 0
    
    # تعديلات حسب خطورة طريقة الإعطاء والتشخيص
    risk_factor = 0
    if route_risk >= 3 and base_class > 0:
        risk_factor += 1
    if diagnosis_risk >= 3 and base_class > 0:
        risk_factor += 1
    if risk_interaction > 9:  # تفاعل عالي الخطورة
        risk_factor += 1
    
    # الفئة النهائية محصورة بين 0 و 3
    final_class = max(0, min(3, base_class + age_factor + emergency_factor + risk_factor))
    
    return int(final_class)

# تطبيق تصنيف الجرعات
df['dosage_class'] = df.apply(classify_dosage, axis=1)

# طباعة معلومات حول البيانات
print(f"Created dataset with {n_samples} samples")
print("\nDosage class distribution:")
class_counts = df['dosage_class'].value_counts()
for cls, count in class_counts.items():
    percentage = count / n_samples * 100
    print(f"Class {cls}: {count} samples ({percentage:.1f}%)")

# إعداد الميزات للتدريب
print("\nPreparing features for training...")

# اختيار الميزات للنموذج
features = df[['age', 'weight', 'drug', 'route', 'gender', 'admission_type', 'diagnosis', 
               'route_risk', 'diagnosis_risk', 'risk_interaction', 'bmi', 
               'age_group', 'weight_group']]
target = df['dosage_class']

# تقسيم البيانات إلى مجموعتي تدريب واختبار
X_train, X_test, y_train, y_test = train_test_split(features, target, test_size=0.25, random_state=42, stratify=target)

print(f"Training set: {X_train.shape[0]} samples")
print(f"Testing set: {X_test.shape[0]} samples")

# تحضير تحويل الأعمدة المختلفة
numeric_features = ['age', 'weight', 'route_risk', 'diagnosis_risk', 'risk_interaction', 'bmi']
categorical_features = ['drug', 'route', 'gender', 'admission_type', 'diagnosis', 'age_group', 'weight_group']

# إنشاء المشفرات مع معالجة محسنة للبيانات
numeric_transformer = Pipeline(steps=[
    ('scaler', StandardScaler())
])

categorical_transformer = Pipeline(steps=[
    ('onehot', OneHotEncoder(handle_unknown='ignore', sparse_output=False))
])

preprocessor = ColumnTransformer(
    transformers=[
        ('num', numeric_transformer, numeric_features),
        ('cat', categorical_transformer, categorical_features)
    ])

# حفظ المشفرات الأصلية للتوقعات
le_drug = LabelEncoder()
le_route = LabelEncoder()
le_gender = LabelEncoder()
le_admission = LabelEncoder()
le_diagnosis = LabelEncoder()

le_drug.fit(df['drug'])
le_route.fit(df['route'])
le_gender.fit(df['gender'])
le_admission.fit(df['admission_type'])
le_diagnosis.fit(df['diagnosis'])

# تطبيق SMOTE لمعالجة عدم توازن البيانات
print("\nApplying SMOTE for class balance...")
smote = SMOTE(random_state=42)
X_train_prep = preprocessor.fit_transform(X_train)
X_train_resampled, y_train_resampled = smote.fit_resample(X_train_prep, y_train)

print(f"Original class distribution: {pd.Series(y_train).value_counts().to_dict()}")
print(f"Resampled class distribution: {pd.Series(y_train_resampled).value_counts().to_dict()}")

# تهيئة النماذج المختلفة
rf_model = RandomForestClassifier(
    n_estimators=200, 
    max_depth=30,
    min_samples_split=5,
    min_samples_leaf=2,
    class_weight='balanced',
    random_state=42,
    n_jobs=-1
)

gb_model = GradientBoostingClassifier(
    n_estimators=200,
    learning_rate=0.05,
    max_depth=7,
    min_samples_split=5,
    min_samples_leaf=2,
    random_state=42
)

xgb_model = xgb.XGBClassifier(
    n_estimators=200,
    learning_rate=0.05,
    max_depth=7,
    gamma=0.1,
    reg_alpha=0.1,
    reg_lambda=1,
    random_state=42,
    n_jobs=-1,
    use_label_encoder=False,
    eval_metric='mlogloss'
)

nn_model = MLPClassifier(
    hidden_layer_sizes=(200, 100, 50),
    activation='relu',
    solver='adam',
    alpha=0.0001,
    batch_size='auto',
    learning_rate='adaptive',
    max_iter=200,
    early_stopping=True,
    random_state=42
)

svm_model = SVC(
    probability=True,
    C=10,
    kernel='rbf',
    gamma='auto',
    class_weight='balanced',
    random_state=42
)

# إنشاء نموذج التصويت - أنسامبل من النماذج المختلفة
voting_model = VotingClassifier(
    estimators=[
        ('rf', rf_model),
        ('gb', gb_model),
        ('xgb', xgb_model),
        ('nn', nn_model)
    ],
    voting='soft',
    n_jobs=-1
)

# تدريب واختبار النماذج المختلفة
models = {
    'Random Forest': rf_model,
    'Gradient Boosting': gb_model,
    'XGBoost': xgb_model,
    'Neural Network': nn_model,
    'Ensemble Model': voting_model
}

# تدريب وتقييم النماذج
results = {}
for name, model in models.items():
    print(f"\nTraining {name} model...")
    start_time = time.time()
    
    model.fit(X_train_resampled, y_train_resampled)
    
    # التنبؤ على بيانات الاختبار
    X_test_prep = preprocessor.transform(X_test)
    y_pred = model.predict(X_test_prep)
    
    # حساب دقة النموذج
    accuracy = accuracy_score(y_test, y_pred)
    results[name] = accuracy
    
    print(f"{name} training time: {time.time() - start_time:.2f} seconds")
    print(f"{name} accuracy: {accuracy:.4f}")
    
    # طباعة تقرير التصنيف
    if name == 'Ensemble Model':  # طباعة التقرير التفصيلي للنموذج النهائي فقط
        print("\nClassification Report:")
        print(classification_report(y_test, y_pred))

# اختيار النموذج الأفضل
best_model_name = max(results, key=results.get)
best_accuracy = results[best_model_name]
best_model = models[best_model_name]

print(f"\nBest model: {best_model_name} with accuracy: {best_accuracy:.4f}")

# حفظ النموذج والمشفرات
print("\nSaving best model and encoders...")
best_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', best_model)
])

# حفظ النموذج والمشفرات
joblib.dump(best_pipeline, 'dosage_model.pkl')

# حفظ المشفرات للاستخدام في التوقعات
encoders = {
    'drug': le_drug,
    'route': le_route,
    'gender': le_gender,
    'admission': le_admission,
    'diagnosis': le_diagnosis,
    'drug_info': drugs_with_typical_doses
}

joblib.dump(encoders, 'encoders.pkl')
print("Model and encoders saved successfully!")

print("\n=== Training complete ===") 