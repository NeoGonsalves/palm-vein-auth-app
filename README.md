BioPay – Palm Vein Biometric Authentication App

BioPay is a secure, end-to-end palm vein authentication system built using Flutter and integrated with the ZK PalmSecure SDK. The application allows users to register, authenticate, and validate identity using palm vein recognition, backed by a real-time Flask server infrastructure and MongoDB.

This project demonstrates a complete biometric login/registration flow including Flutter frontend, native Android SDK integration, and a Flask backend with WebSocket communication and token-based security.
Features

    User Registration with email, phone, and password

    Login with email/phone and password or Google Sign-In

    Palm vein scanning using the ZK PalmSecure SDK (native Android via JNI)

    Secure user authentication using JWT

    Real-time palm scan validation with Flask-SocketIO

    RESTful backend API using Flask and MongoDB

    Palm vein device simulation mode for development/testing without hardware

Tech Stack

Frontend (Mobile)

    Flutter (Dart)

    MethodChannel (Flutter ↔ Android native)

    Android NDK / JNI for integrating ZK SDK

    Flutter Material UI

Backend (Server)

    Python Flask

    Flask-SocketIO (real-time WebSocket communication)

    Flask-CORS

    Flask-Limiter

    PyMongo (MongoDB client)

    bcrypt (password hashing)

    JWT (token-based authentication)

Database

    MongoDB

Folder Structure

.
├── BioPay/
│ ├── flask_backend/
│ │ ├── demo_app.py
│ │ ├── jwt_utils.py
│ │ ├── templates/
│ │ └── static/
│ └── zk_palmscanner_app/
│ ├── android/
│ ├── lib/
│ │ ├── main.dart
│ │ ├── config.dart
│ │ ├── palm_scanner.dart
│ │ └── screens/
│ │ ├── login_screen.dart
│ │ ├── register_screen.dart
│ │ └── palm_scanner_screen.dart
│ └── pubspec.yaml
Getting Started

Prerequisites

    Flutter SDK (latest stable)

    Android Studio (with NDK side-by-side installed)

    Python 3.9+

    MongoDB installed and running locally or remotely

    PalmSecure SDK (ZK SDK v1.0.7)

Setup Instructions

Step 1: Backend Setup (Flask)

Navigate to the backend directory:

cd flask_backend

Create and activate virtual environment:

python3 -m venv venv
source venv/bin/activate # Windows: venv\Scripts\activate

Install dependencies:

pip install -r requirements.txt

Start the Flask server:

python demo_app.py

# ZK Palm Scanner App

A Flutter-based biometric authentication app integrating with the ZK PalmSecure SDK for palm vein recognition. Real-time validation is supported via WebSocket.

---

## 📦 Step 2: Flutter App Setup

### 1. Navigate to the Flutter project

bash
cd zk_palmscanner_app

2. Install dependencies

flutter pub get

3. Update API base URLs in lib/config.dart

Replace YOUR_LOCAL_IP with your machine’s local IP address:

const String backendBaseUrl = 'http://YOUR_LOCAL_IP:5000';
const String websocketUrl = 'ws://YOUR_LOCAL_IP:5000/socket.io/?EIO=4&transport=websocket';

    ⚠️ Note: Do not use localhost or 127.0.0.1 for backendBaseUrl unless you're running the app on an emulator.

4. Run the app (physical device required for USB SDK)

flutter run --release

⚙️ Step 3: SDK Integration (Android)

    Copy SDK Files
    Place the ZK SDK .jar and .so files inside:

android/app/libs/

Configure JNI and packaging options
Modify android/app/build.gradle.kts:

    android {
        ...
        sourceSets {
            getByName("main") {
                jniLibs.srcDirs("libs")
            }
        }
        packagingOptions {
            pickFirst("lib/**/libzkfinger.so")
        }
    }

    Add native code bridging
    Use Flutter’s MethodChannel to invoke native SDK methods from Dart.

    Handle USB Permissions
    Set up PendingIntent and BroadcastReceiver in MainActivity.kt for USB permission handling.

    🔍 See integration details in MainActivity.kt and AndroidManifest.xml.

📡 API Endpoints
Method	Endpoint	Description
POST	/api/register_user	Registers a user (email, phone, password, bioId)
POST	/api/validate_bio	Validates bioId and returns user info
POST	/api/simulate_bio	Triggers a mock validation event (for dev)
GET	/api/device/status	Returns device status (real/simulated)
🔄 WebSocket Event

    bio_validation — Emitted upon successful biometric match or simulation.

📝 Notes

    A ZK PalmSecure device and SDK are required for actual biometric scanning.

    For development without hardware, use demo_app.py to simulate device behavior.

    WebSocket is used for real-time push of validation results to the client.

🚧 To-Do / Future Improvements

Integrate Firebase or OAuth (Google Sign-In)

Add biometric template management (enroll/delete)

Implement live detection, retries, and fallback flows

Secure backend with HTTPS and token-based auth

    Improve Flutter UI for error/success feedback

📄 License

This project is for research and prototyping only. You may modify or distribute with proper attribution.

    ⚠️ The ZK PalmSecure SDK is governed by the vendor’s license agreement and must not be redistributed.


---
