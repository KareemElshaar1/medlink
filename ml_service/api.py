from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import Optional
import joblib
import uvicorn
import os
import numpy as np
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="MedLink Drug Dosage API", 
              description="واجهة برمجة تطبيقات متقدمة لتصنيف الجرعات الدوائية",
              version="2.0")

# تكوين CORS لتمكين الوصول من المتصفح
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # يسمح بالوصول من أي أصل
    allow_credentials=True,
    allow_methods=["*"],  # يسمح بكل الطرق
    allow_headers=["*"],  # يسمح بكل الترويسات
)

# تحميل النموذج والمشفرات
try:
    model = joblib.load(r'D:\untitled6\ml_service\dosage_model.pkl')
    encoders = joblib.load(r'D:\untitled6\ml_service\encoders.pkl')
    print("Model and encoders loaded successfully")
except Exception as e:
    print(f"Error loading model: {str(e)}")
    # تهيئة كـ None وفحص قبل التوقعات
    model = None
    encoders = None

class PatientData(BaseModel):
    age: float = Field(..., description="عمر المريض", example=65)
    weight: Optional[float] = Field(None, description="وزن المريض بالكيلوغرام", example=70)
    drug: str = Field(..., description="اسم الدواء", example="Aspirin")
    route: str = Field(..., description="طريقة إعطاء الدواء", example="Oral")
    gender: str = Field(..., description="جنس المريض (M/F)", example="M")
    admission_type: str = Field(..., description="نوع الدخول", example="EMERGENCY")
    diagnosis: Optional[str] = Field(None, description="التشخيص", example="Hypertension")

class DosagePrediction(BaseModel):
    dosage_class: int = Field(..., description="فئة الجرعة (0-3)")
    dosage_label: str = Field(..., description="تسمية الجرعة")
    confidence: float = Field(..., description="مستوى الثقة في التوقع")
    recommendation: str = Field(..., description="التوصية")
    normal_range: Optional[str] = Field(None, description="النطاق الطبيعي للدواء")

@app.get("/")
def read_root():
    return {"message": "MedLink Drug Dosage API is running", "status": "active"}

@app.post("/predict", response_model=DosagePrediction)
def predict_dosage(data: PatientData):
    if model is None or encoders is None:
        raise HTTPException(status_code=500, detail="Model not loaded")
    
    try:
        # استخراج الميزات
        features = {}
        
        # الميزات العددية
        features['age'] = data.age
        features['weight'] = data.weight if data.weight else 70  # قيمة افتراضية

        # التشفير للبيانات التصنيفية
        try:
            drug_encoded = -1
            if data.drug in encoders['drug'].classes_:
                drug_encoded = encoders['drug'].transform([data.drug])[0]
            else:
                # محاولة العثور على أقرب دواء
                closest_drug = find_closest_match(data.drug, list(encoders['drug'].classes_))
                if closest_drug:
                    drug_encoded = encoders['drug'].transform([closest_drug])[0]
            
            route_encoded = encoders['route'].transform([data.route])[0] if data.route in encoders['route'].classes_ else -1
            gender_encoded = encoders['gender'].transform([data.gender])[0] if data.gender in encoders['gender'].classes_ else -1
            admission_encoded = encoders['admission'].transform([data.admission_type])[0] if data.admission_type in encoders['admission'].classes_ else -1
            
            # التشخيص اختياري
            diagnosis_encoded = -1
            if data.diagnosis and 'diagnosis' in encoders:
                if data.diagnosis in encoders['diagnosis'].classes_:
                    diagnosis_encoded = encoders['diagnosis'].transform([data.diagnosis])[0]
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"Error encoding features: {str(e)}")
        
        # فحص القيم غير المعروفة
        if -1 in [drug_encoded, route_encoded, gender_encoded, admission_encoded]:
            missing_features = []
            if drug_encoded == -1:
                missing_features.append(f"Drug '{data.drug}' not recognized")
            if route_encoded == -1:
                missing_features.append(f"Route '{data.route}' not recognized")
            if gender_encoded == -1:
                missing_features.append(f"Gender '{data.gender}' not recognized")
            if admission_encoded == -1:
                missing_features.append(f"Admission type '{data.admission_type}' not recognized")
            
            raise HTTPException(status_code=400, detail=f"Unknown category values: {', '.join(missing_features)}")
        
        # إنشاء مصفوفة الميزات
        if hasattr(model, 'predict_proba'):
            # نموذج يدعم احتمالات التوقع
            # إنشاء المصفوفة بالبنية المطلوبة
            feature_dict = {
                'age': data.age,
                'weight': features['weight'],
                'drug': data.drug,
                'route': data.route,
                'gender': data.gender,
                'admission_type': data.admission_type,
                'diagnosis': data.diagnosis if data.diagnosis else "Not specified"
            }
            
            # حصول على التوقع
            import pandas as pd
            feature_df = pd.DataFrame([feature_dict])
            prediction = model.predict(feature_df)[0]
            probabilities = model.predict_proba(feature_df)[0]
            confidence = probabilities[prediction]
        else:
            # طريقة احتياطية للنماذج البسيطة
            features_array = [[data.age, drug_encoded, route_encoded, gender_encoded, admission_encoded]]
            prediction = model.predict(features_array)[0]
            confidence = 0.8  # قيمة افتراضية
        
        # توليد تسمية الجرعة والتوصية
        dosage_labels = {0: "Low dose", 1: "Medium-low dose", 2: "Medium-high dose", 3: "High dose"}
        
        recommendations = {
            0: "الجرعة منخفضة. يجب متابعة فعالية العلاج والنظر في زيادة الجرعة إذا لم يكن هناك استجابة مناسبة.",
            1: "الجرعة متوسطة-منخفضة. جرعة آمنة في معظم الحالات مع الحاجة إلى مراقبة الفعالية.",
            2: "الجرعة متوسطة-مرتفعة. مراقبة المريض للآثار الجانبية المحتملة مع الحفاظ على فعالية العلاج.",
            3: "الجرعة مرتفعة. توخي الحذر ومراقبة المريض بعناية للتفاعلات السلبية والآثار الجانبية."
        }
        
        # استخراج نطاق الجرعة الطبيعي للدواء المحدد إذا كان متاحا
        normal_range = None
        if 'drug_info' in encoders and data.drug in encoders['drug_info']:
            drug_info = encoders['drug_info'][data.drug]
            normal_range = f"{drug_info['min']} - {drug_info['max']} {drug_info['unit']}"
        
        # إضافة توصيات إضافية حسب العمر
        age_specific = ""
        if data.age < 18:
            age_specific = " (يجب مراعاة تعديلات الجرعة للأطفال)"
        elif data.age > 65:
            age_specific = " (قد يحتاج كبار السن إلى جرعات مخفضة)"
        
        # دمج التوصيات
        final_recommendation = recommendations[prediction] + age_specific
        
        return DosagePrediction(
            dosage_class=int(prediction),
            dosage_label=dosage_labels[prediction],
            confidence=float(confidence),
            recommendation=final_recommendation,
            normal_range=normal_range
        )
        
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@app.get("/health")
def health_check():
    if model is None or encoders is None:
        return {"status": "error", "message": "Model not loaded"}
    return {"status": "ok", "message": "Service is healthy"}

@app.get("/drugs")
def list_drugs():
    """الحصول على قائمة الأدوية المدعومة"""
    if encoders is None:
        raise HTTPException(status_code=500, detail="Encoders not loaded")
    
    try:
        if 'drug' in encoders:
            drug_list = list(encoders['drug'].classes_)
            return {"drugs": drug_list}
        elif 'drug_info' in encoders:
            drug_list = list(encoders['drug_info'].keys())
            return {"drugs": drug_list}
        else:
            raise HTTPException(status_code=500, detail="Drug information not available")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving drugs: {str(e)}")

def find_closest_match(search_term, options, threshold=0.7):
    """العثور على أقرب تطابق لمصطلح البحث في الخيارات المتاحة"""
    from difflib import SequenceMatcher
    
    best_match = None
    best_ratio = 0
    
    search_term = search_term.lower()
    for option in options:
        ratio = SequenceMatcher(None, search_term, option.lower()).ratio()
        if ratio > best_ratio and ratio > threshold:
            best_ratio = ratio
            best_match = option
    
    return best_match

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True) 