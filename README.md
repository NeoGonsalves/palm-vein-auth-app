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

Step 2: Flutter App Setup

Navigate to the Flutter project:

cd zk_palmscanner_app

Install dependencies:

flutter pub get

Update backendBaseUrl in lib/config.dart:

const String backendBaseUrl = 'http://YOUR_LOCAL_IP:5000';
const String websocketUrl = 'ws://YOUR_LOCAL_IP:5000/socket.io/?EIO=4&transport=websocket';

Run on physical device (required for USB SDK):

flutter run --release

Note: Do not use localhost or 127.0.0.1 for backendBaseUrl unless running in emulator.

Step 3: SDK Integration (Android)

    Copy the ZK SDK JARs and .so libraries into android/app/libs

    Add JNI and packaging config in build.gradle.kts

    Use MethodChannel to call native functions from Flutter

    USB permission is requested via PendingIntent and BroadcastReceiver

See integration steps in Android MainActivity.kt and Manifest.
API Endpoints

POST /api/register_user

Registers a new user with email, phone, password, and bioId.

POST /api/validate_bio

Validates bioId and returns user details if matched.

POST /api/simulate_bio

Emits a mock validation event for development.

GET /api/device/status

Returns current device status (simulated or real).

WebSocket Event: bio_validation

Emitted on successful scan simulation or match.
Notes

    Device scanning and real biometric validation require the ZK PalmSecure device and SDK.

    For development without hardware, demo_app.py includes simulation endpoints.

    WebSocket is used to push validation results from backend to client in real-time.

To-Do / Future Improvements

    Integrate Firebase or OAuth-based Google Sign-In

    Add biometric template management (enrollment, deletion)

    Support additional SDK features (live detection, retries)

    Deploy backend with HTTPS and proper authorization headers

    Add Flutter error handling and success/fail UI states

License

This project is intended for research and prototyping purposes. You may modify and distribute with proper attribution. The ZK PalmSecure SDK is subject to the vendor’s license agreement and may not be redistributed.
