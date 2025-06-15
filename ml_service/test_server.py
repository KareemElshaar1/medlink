import requests
import time
import sys
import json

def test_server(base_url="http://localhost:8000"):
    print(f"Testing connection to ML server at {base_url}...")
    
    # Test the health endpoint
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        if response.status_code == 200:
            health_data = response.json()
            if health_data.get('status') == 'ok':
                print("✅ Server is healthy!")
            else:
                print("⚠️ Server is running but model is not loaded properly.")
                print(f"   Message: {health_data.get('message', 'Unknown')}")
        else:
            print(f"❌ Health check failed! Status code: {response.status_code}")
            print(f"   Response: {response.text}")
    except requests.exceptions.RequestException as e:
        print(f"❌ Connection error: {e}")
        print("\nMake sure the server is running with 'python api.py'")
        return False
    
    # Test a sample prediction
    print("\nTesting sample prediction...")
    sample_data = {
        "age": 65,
        "drug": "Aspirin",
        "route": "Oral",
        "gender": "M",
        "admission_type": "EMERGENCY"
    }
    
    try:
        response = requests.post(
            f"{base_url}/predict",
            json=sample_data,
            timeout=10
        )
        
        if response.status_code == 200:
            prediction = response.json()
            print("✅ Prediction successful!")
            print("\nSample Prediction Results:")
            print(f"  - Dosage Class: {prediction.get('dosage_class')}")
            print(f"  - Dosage Label: {prediction.get('dosage_label')}")
            print(f"  - Confidence: {prediction.get('confidence', 0) * 100:.1f}%")
            print(f"  - Recommendation: {prediction.get('recommendation')}")
            return True
        else:
            print(f"❌ Prediction failed! Status code: {response.status_code}")
            try:
                error_data = response.json()
                print(f"   Error: {error_data.get('detail', 'Unknown error')}")
                
                if error_data.get('detail', '').lower().startswith('model not loaded'):
                    print("\nThe model needs to be trained first. Run:")
                    print("   python train_model.py")
            except:
                print(f"   Response: {response.text}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Connection error during prediction: {e}")
        return False
    
if __name__ == "__main__":
    print("=" * 50)
    print("MedLink ML Server Test")
    print("=" * 50)
    
    url = "http://localhost:8000"
    if len(sys.argv) > 1:
        url = sys.argv[1]
    
    success = test_server(url)
    
    print("\n" + "=" * 50)
    if success:
        print("All tests passed! The server is ready.")
    else:
        print("Tests failed. Please check the errors above.")
    print("=" * 50) 