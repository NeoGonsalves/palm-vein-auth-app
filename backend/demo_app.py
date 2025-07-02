

"""
PalmSecure SDK Demo Web Application

This script provides a web-based demonstration of the PalmSecure SDK functionality.
"""
import eventlet
eventlet.monkey_patch()
import logging
import os
import warnings
import sys
import time
import json
import bcrypt
from flask import Flask, request, jsonify, render_template, redirect, url_for, flash
from flask_cors import CORS
from flask_socketio import SocketIO, emit
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from pymongo import MongoClient
from jwt_utils import generate_token
from jwt_utils import decode_token
#from palm_secure import PalmSecureDevice, find_devices, get_version
#from palm_secure.exceptions import DeviceNotFoundError, ConnectionError
#from palm_secure.diagnostics import DiagnosticsManager

# Logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
logging.getLogger("pymongo").setLevel(logging.WARNING)
logger = logging.getLogger(__name__)
warnings.filterwarnings("ignore")
# Flask app and extensions
app = Flask(__name__)
app.secret_key = os.environ.get("SESSION_SECRET", os.urandom(24).hex())
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*")
limiter = Limiter(get_remote_address, app=app, default_limits=["200 per day", "50 per hour"])

# MongoDB setup
client = MongoClient("mongodb://localhost:27017/")
db = client['palm_vein_auth']
users_collection = db['users']

# App state
app_state = {
    'devices': [],
    'connected_device': None,
    'diagnostic_results': None,
    'last_refresh': 0,
    'backend_available': True
}


@app.route('/api/register_user', methods=['POST'])
@limiter.limit("5/minute")
def register_user():
    data = request.json
    bio_id = data.get("bio_id", "").strip()
    username = data.get("username")
    email = data.get("email")
    phone = data.get("phone")

    if not all([bio_id, username, email, phone]):
        return jsonify({"error": "Missing fields"}), 400

    if users_collection.find_one({"email": email}):
        return jsonify({"error": "User with this email already exists."}), 400
    if users_collection.find_one({"username": username}):
        return jsonify({"error": "User with this username already exists."}), 400

    bio_id_hash = bcrypt.hashpw(bio_id.encode('utf-8'), bcrypt.gensalt())
    user = {
        "username": username,
        "email": email,
        "phone": phone,
        "bio_id_hash": bio_id_hash.decode('utf-8')
    }

    result = users_collection.insert_one(user)
    token = generate_token({
        "username": username,
        "email": email
    })

    return jsonify({
        "message": "User registered",
        "user_id": str(result.inserted_id),
        "token": token
    }), 201
from jwt_utils import generate_token
from jwt_utils import decode_token

@app.route('/api/validate_bio', methods=['POST'])
@limiter.limit("10/minute")
def validate_bio():
    data = request.json
    bio_id = data.get("bio_id", "").strip().encode('utf-8')

    for user in users_collection.find():
        stored_hash = user.get('bio_id_hash', '').encode('utf-8')
        if bcrypt.checkpw(bio_id, stored_hash):
         
            token = generate_token({
                "username": user['username'],
                "email": user['email']
            })

            user_info = {
                "username": user['username'],
                "email": user['email'],
                "phone": user['phone']
            }


            socketio.emit('bio_validation', {
                "status": "success",
                "user": user_info,
                "token": token
            })

    
            return jsonify({
                "match": True,
                "user": user_info,
                "token": token
            })

 
    socketio.emit('bio_validation', {
        "status": "fail",
        "reason": "No match"
    })
    return jsonify({"match": False, "reason": "No match"}), 404
@app.route('/api/scan_bio_id', methods=['GET'])
def scan_bio_id():
    """
    Placeholder route for capturing Bio ID from palm scanner.
    Returns a mock Bio ID for now (for frontend/backend development)
    Device team can uncomment and integrate ZKPalm12 SDK below
    """
    
    try:
        return jsonify({"bio_id": "MOCKBIO123456"})

        
    except Exception as e:
        return jsonify({"error": f"Unexpected error: {str(e)}"}), 500

#
@app.route('/api/simulate_bio', methods=['POST'])
def simulate_bio_validation():
    socketio.emit('bio_validation', {"status": "validated", "user": "demo_user"})
    return jsonify({"message": "Bio validation simulated"})

# Socket.IO
@socketio.on('connect')
def handle_connect():
    emit('message', {'msg': 'WebSocket connected'})


def refresh_devices():
    """Simulate refresh of available devices (no hardware)."""
    current_time = time.time()

    if current_time - app_state['last_refresh'] > 5:
        try:
            # Simulate empty device list (no hardware connected)
            app_state['devices'] = []
            app_state['last_refresh'] = current_time
            app_state['backend_available'] = True
            logger.info("Simulated device scan: no devices found")
        except Exception as e:
            app_state['devices'] = []
            app_state['last_refresh'] = current_time
            app_state['backend_available'] = False
            logger.error(f"Error during simulated device refresh: {str(e)}")

@app.route('/')
def index():
    """Render the main index page."""
    refresh_devices()
    sdk_version = get_version()
    return render_template('index.html', 
                          devices=app_state['devices'], 
                          connected=app_state['connected_device'] is not None,
                          backend_available=app_state['backend_available'],
                          sdk_version=sdk_version)


@app.route('/devices')
def devices():
    """Return the list of available devices as JSON."""
    refresh_devices()
    return jsonify(app_state['devices'])


@app.route('/connect/<int:device_index>', methods=['POST'])
def connect_device(device_index):
    """
    Connect to a specific device.
    
    Args:
        device_index: Index of the device in the devices list
    """
    refresh_devices()
    
    if device_index >= len(app_state['devices']):
        flash("Invalid device index", "error")
        return redirect(url_for('index'))
    
    # If we're already connected to a device, disconnect it first
    if app_state['connected_device'] is not None:
        try:
            app_state['connected_device'].disconnect()
        except Exception as e:
            logger.error(f"Error disconnecting device: {str(e)}")
        app_state['connected_device'] = None
    
    try:
        # Connect to the selected device
        device = PalmSecureDevice(app_state['devices'][device_index])
        device.connect()
        app_state['connected_device'] = device
        
        flash(f"Successfully connected to device {device_index + 1}", "success")
        return redirect(url_for('device_detail'))
    
    except ConnectionError as e:
        flash(f"Error connecting to device: {str(e)}", "error")
        return redirect(url_for('index'))
    
    except Exception as e:
        flash(f"Unexpected error: {str(e)}", "error")
        return redirect(url_for('index'))


@app.route('/device')
def device_detail():
    """Show details for the connected device."""
    if app_state['connected_device'] is None:
        flash("No device connected", "error")
        return redirect(url_for('index'))
    
    try:
        # Get device information
        info = app_state['connected_device'].get_device_info()
        
        # Get device status
        status = app_state['connected_device'].get_status()
        
        return render_template('device.html', 
                              info=info, 
                              status=status,
                              connected=True)
    
    except Exception as e:
        flash(f"Error getting device details: {str(e)}", "error")
        return redirect(url_for('index'))


@app.route('/device/initialize', methods=['POST'])
def initialize_device():
    """Initialize the connected device."""
    if app_state['connected_device'] is None:
        flash("No device connected", "error")
        return redirect(url_for('index'))
    
    try:
        # Initialize the device
        if app_state['connected_device'].initialize():
            flash("Device initialized successfully", "success")
        else:
            flash("Failed to initialize device", "warning")
        
        return redirect(url_for('device_detail'))
    
    except Exception as e:
        flash(f"Error initializing device: {str(e)}", "error")
        return redirect(url_for('device_detail'))


@app.route('/device/reset', methods=['POST'])
def reset_device():
    """Reset the connected device."""
    if app_state['connected_device'] is None:
        flash("No device connected", "error")
        return redirect(url_for('index'))
    
    try:
        # Reset the device
        if app_state['connected_device'].reset():
            flash("Device reset successfully", "success")
        else:
            flash("Failed to reset device", "warning")
        
        return redirect(url_for('device_detail'))
    
    except Exception as e:
        flash(f"Error resetting device: {str(e)}", "error")
        return redirect(url_for('device_detail'))


@app.route('/device/disconnect', methods=['POST'])
def disconnect_device():
    """Disconnect from the current device."""
    if app_state['connected_device'] is None:
        flash("No device connected", "error")
        return redirect(url_for('index'))
    
    try:
        # Disconnect from the device
        app_state['connected_device'].disconnect()
        app_state['connected_device'] = None
        
        flash("Device disconnected successfully", "success")
        return redirect(url_for('index'))
    
    except Exception as e:
        flash(f"Error disconnecting device: {str(e)}", "error")
        return redirect(url_for('device_detail'))


@app.route('/diagnostics')
def diagnostics():
    """Run diagnostics and show results."""
    # Create diagnostics manager
    diag_manager = DiagnosticsManager()
    
    try:
        # Run all diagnostic tests
        app_state['diagnostic_results'] = diag_manager.run_all_diagnostics()
        
        # Create a copy of the results so we can modify it safely for the template
        template_results = app_state['diagnostic_results'].copy()
        
        # Make sure the overall section exists
        if 'overall' not in template_results:
            template_results['overall'] = {
                'status': 'warning',
                'message': 'Diagnostic assessment incomplete',
            }
        
        # If backend is not available, update overall status accordingly
        if not app_state['backend_available']:
            # If backend is not available, mark some sections as errors
            template_results['overall'] = {
                'status': 'warning',
                'message': 'Limited functionality due to missing USB backend',
                'warnings': ['USB backend not available in this environment'],
                'critical_issues': []
            }
            
            # Set system compatibility to error
            template_results['system_compatibility'] = {
                'status': 'error',
                'compatible': False,
                'issues': ['USB backend not available in cloud environment',
                           'This is expected in Replit or similar environments',
                           'For hardware access, run on a local machine with proper drivers'],
                'message': 'Limited functionality in cloud environment'
            }
            
            # Set driver check to error
            template_results['driver_check'] = {
                'status': 'error',
                'installed': False,
                'version': 'Unknown',
                'compatible': False,
                'message': 'Driver detection not possible in cloud environment',
                'details': ['PalmSecure drivers cannot be detected in Replit environment',
                            'This is normal when running in a cloud environment',
                            'Proper drivers are required for device operation on local machines']
            }
        else:
            # Ensure system_compatibility exists to prevent template errors
            if 'system_compatibility' not in template_results:
                template_results['system_compatibility'] = {
                    'status': 'warning',
                    'compatible': False,
                    'issues': ['System compatibility check not completed']
                }
            
            # Ensure driver_check exists
            if 'driver_check' not in template_results:
                template_results['driver_check'] = {
                    'status': 'warning',
                    'installed': False,
                    'version': 'Unknown',
                    'compatible': False,
                    'message': 'Driver check not performed',
                    'details': []
                }
        
        # Ensure all other sections expected by the template exist
        required_sections = ['usb_subsystem', 'permissions', 'device_detection', 'network']
        for section in required_sections:
            if section not in template_results:
                template_results[section] = {
                    'status': 'unknown',
                    'message': f'{section.replace("_", " ").title()} check not performed',
                    'details': []
                }
        
        # Ensure case consistency in status values
        for section_name, section in template_results.items():
            if isinstance(section, dict) and 'status' in section:
                # Convert status to lowercase for consistent template checking
                section['status'] = section['status'].lower()
        
        return render_template('diagnostics.html', 
                              results=template_results,
                              connected=app_state['connected_device'] is not None,
                              backend_available=app_state['backend_available'])
    
    except Exception as e:
        import traceback
        logger.error(f"Diagnostics error: {str(e)}")
        logger.error(traceback.format_exc())
        flash(f"Error running diagnostics: {str(e)}", "error")
        return redirect(url_for('index'))


@app.route('/api/diagnostics/report')
def diagnostic_report():
    """Generate and return a diagnostic report."""
    if app_state['diagnostic_results'] is None:
        return jsonify({'error': 'No diagnostic results available'})
    
    try:
        # Create diagnostics manager
        diag_manager = DiagnosticsManager()
        
        # Generate report
        report = diag_manager.generate_report()
        
        return jsonify({'report': report})
    
    except Exception as e:
        return jsonify({'error': str(e)})


@app.route('/api/device/status')
def device_status():
    """Return the current device status as JSON."""
    if app_state['connected_device'] is None:
        return jsonify({'connected': False})
    
    try:
        # Get device status
        status = app_state['connected_device'].get_status()
        status['connected'] = True
        
        return jsonify(status)
    
    except Exception as e:
        return jsonify({'connected': False, 'error': str(e)})


@app.errorhandler(404)
def page_not_found(e):
    """Handle 404 errors."""
    return render_template('404.html', connected=app_state['connected_device'] is not None), 404


@app.errorhandler(500)
def server_error(e):
    """Handle 500 errors."""
    logger.error(f"Server error: {str(e)}")
    return render_template('500.html', connected=app_state['connected_device'] is not None), 500


@app.teardown_appcontext
def cleanup(exception=None):
    """Clean up resources when the application shuts down."""
    if app_state['connected_device'] is not None:
        try:
            app_state['connected_device'].disconnect()
        except Exception as e:
            logger.error(f"Error disconnecting device during cleanup: {str(e)}")
        app_state['connected_device'] = None

if __name__ == '__main__':
    try:
        socketio.run(app, host='0.0.0.0', port=5000, debug=True)
    except Exception as e:
        logger.error(f"Error starting app: {str(e)}")
        sys.exit(1)
