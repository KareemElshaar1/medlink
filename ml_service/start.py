import os
import subprocess
import sys
import time

print("""
╔════════════════════════════════════════╗
║   MedLink Advanced Dosage API Server   ║
╚════════════════════════════════════════╝
""")

def run_command(command):
    """تنفيذ أمر في نظام التشغيل مع عرض المخرجات"""
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    while True:
        line = process.stdout.readline()
        if not line and process.poll() is not None:
            break
        if line:
            print(line.strip())
    return process.returncode

print("Installing required packages...")
run_command("pip install -r requirements.txt")

print("\nTraining advanced model with high accuracy...")
run_command("python advanced_model.py")

# التحقق من وجود ملفات النموذج
model_exists = os.path.exists("D:\untitled6\ml_service\dosage_model.pkl")
encoders_exist = os.path.exists("D:\untitled6\ml_service\encoders.pkl")

if not model_exists or not encoders_exist:
    print("\n❌ فشل في إنشاء ملفات النموذج!")
    sys.exit(1)

print("\n✅ تم تدريب النموذج بنجاح وتم حفظ الملفات!")

print("\n⚡ بدء تشغيل الخادم على http://localhost:8000")
print("اضغط على Ctrl+C للخروج من الخادم.")

# تشغيل الخادم
run_command("python -m uvicorn api:app --host 0.0.0.0 --port 8000") 