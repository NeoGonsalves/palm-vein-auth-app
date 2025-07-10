import requests
import json

# 🔁 Update this to match your backend IP if not localhost
BASE_URL = "http://localhost:5000"

# 🧍 Simulate user details
test_user = {
    "bio_id": "MOCKBIO123456",
    "username": "vedanti_user",
    "email": "vedanti@example.com",
    "phone": "9876543210"
}

def register_user():
    print("\n📥 Registering User...")
    url = f"{BASE_URL}/api/register_user"
    response = requests.post(url, json=test_user)
    print("Status:", response.status_code)
    print("Response:", response.json())

def validate_bio():
    print("\n🔐 Validating Bio ID...")
    url = f"{BASE_URL}/api/validate_bio"
    response = requests.post(url, json={"bio_id": test_user["bio_id"]})
    print("Status:", response.status_code)
    print("Response:", response.json())

def simulate_bio():
    print("\n🧪 Simulating Bio Scan Event...")
    url = f"{BASE_URL}/api/simulate_bio"
    response = requests.post(url)
    print("Status:", response.status_code)
    print("Response:", response.json())

def scan_bio_id():
    print("\n📸 Getting Mock Bio ID...")
    url = f"{BASE_URL}/api/scan_bio_id"
    response = requests.get(url)
    print("Status:", response.status_code)
    print("Response:", response.json())

if __name__ == "__main__":
    register_user()
    validate_bio()
    simulate_bio()
    scan_bio_id()
