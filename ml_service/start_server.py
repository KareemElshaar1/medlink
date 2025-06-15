import os
import subprocess
import sys
import time

print("""
╔════════════════════════════════════════╗
║   MedLink Advanced Dosage API Server   ║
╚════════════════════════════════════════╝
""")
print("Starting API server...")
print("Checking model files...")

# استخدم raw strings لتجنب أخطاء unicode
model_path = r"D:\untitled6\ml_service\dosage_model.pkl"
encoders_path = r"D:\untitled6\ml_service\encoders.pkl"

model_exists = os.path.exists(model_path)
encoders_exist = os.path.exists(encoders_path)

print(f"✓ Model file exists: {model_exists}")
print(f"✓ Encoders file exists: {encoders_exist}")

if not model_exists or not encoders_exist:
    print("\n⚠️ WARNING: Model or encoders not found!")
    print("You need to train the model first using:")
    print("    python advanced_model.py")

    choice = input("\nDo you want to train the model now? (y/n): ")

    if choice.lower() == 'y':
        print("\nStarting model training...")
        try:
            os.system("python advanced_model.py")

            # Check again if files were created
            model_exists = os.path.exists(model_path)
            encoders_exist = os.path.exists(encoders_path)

            if not model_exists or not encoders_exist:
                print("\n❌ Training failed to create model files!")
                sys.exit(1)
            else:
                print("\n✓ Training completed successfully!")
        except Exception as e:
            print(f"\n❌ Error during training: {str(e)}")
            sys.exit(1)
    else:
        print("\n❌ Cannot start server without model files.")
        sys.exit(1)

print("\n✓ All required files found!")
print("\n⚡ Starting server on http://localhost:8000")
print("Press Ctrl+C to stop the server.")

# Run the API server
os.system("python ml_service/api.py")

