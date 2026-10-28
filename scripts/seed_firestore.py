#!/usr/bin/env python3
import json
import os
import plistlib
import urllib.request
import urllib.parse
import urllib.error

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PLIST_PATH = os.path.join(BASE_DIR, "mediConnect", "GoogleService-Info.plist")
DOCTORS_PATH = os.path.join(BASE_DIR, "scripts", "doctors.json")
CLINICS_PATH = os.path.join(BASE_DIR, "scripts", "clinics.json")

def read_plist_config():
    if not os.path.exists(PLIST_PATH):
        raise FileNotFoundError(f"Missing GoogleService-Info.plist at {PLIST_PATH}")
    with open(PLIST_PATH, "rb") as fp:
        plist = plistlib.load(fp)
    return plist["API_KEY"], plist["PROJECT_ID"]

def get_auth_token(api_key):
    url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={api_key}"
    payload = {
        "email": "admin@mediconnect.app",
        "password": "MediConnect@2026!",
        "returnSecureToken": True
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req) as response:
            res = json.loads(response.read().decode("utf-8"))
            return res["idToken"]
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8")
        if "EMAIL_NOT_FOUND" in error_body:
            signup_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signUp?key={api_key}"
            signup_req = urllib.request.Request(
                signup_url,
                data=json.dumps(payload).encode("utf-8"),
                headers={"Content-Type": "application/json"}
            )
            with urllib.request.urlopen(signup_req) as s_res:
                s_data = json.loads(s_res.read().decode("utf-8"))
                return s_data["idToken"]
        raise

def to_firestore_value(val):
    if val is None:
        return {"nullValue": None}
    elif isinstance(val, bool):
        return {"booleanValue": val}
    elif isinstance(val, int):
        return {"integerValue": str(val)}
    elif isinstance(val, float):
        return {"doubleValue": val}
    elif isinstance(val, str):
        return {"stringValue": val}
    elif isinstance(val, list):
        return {"arrayValue": {"values": [to_firestore_value(v) for v in val]}}
    elif isinstance(val, dict):
        return {"mapValue": {"fields": {k: to_firestore_value(v) for k, v in val.items()}}}
    return {"stringValue": str(val)}

def upload_document(project_id, collection, doc_id, data_dict, token):
    encoded_id = urllib.parse.quote(str(doc_id))
    url = f"https://firestore.googleapis.com/v1/projects/{project_id}/databases/(default)/documents/{collection}/{encoded_id}"
    fields = {k: to_firestore_value(v) for k, v in data_dict.items()}
    body = {"fields": fields}
    
    req = urllib.request.Request(
        url,
        data=json.dumps(body).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        },
        method="PATCH"
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode("utf-8"))

def main():
    print("🚀 MediConnect — Cloud Firestore Data Seeder")
    api_key, project_id = read_plist_config()
    print(f"📦 Target Firebase Project: {project_id}")
    
    print("🔐 Authenticating admin session...")
    token = get_auth_token(api_key)
    print("✅ Authenticated successfully.")
    
    # 1. Seed Doctors
    with open(DOCTORS_PATH, "r") as f:
        doctors = json.load(f)
    print(f"\n🩺 Seeding {len(doctors)} Colombo medical specialists...")
    for doc in doctors:
        doc_id = doc.get("id")
        upload_document(project_id, "doctors", doc_id, doc, token)
        name = doc.get("user", {}).get("fullName", doc_id)
        spec = doc.get("specialization", "")
        hosp = doc.get("hospital", "")
        print(f"   ✓ Seeded: {name} ({spec} @ {hosp})")
        
    # 2. Seed Sample Live Queue Room
    print("\n⏱️ Seeding initial live queue snapshot (Room 204)...")
    queue_data = {
        "roomNumber": "Room 204",
        "doctorId": "doc-001",
        "nowServingToken": "A-07",
        "nowServingStatus": "In Examination",
        "activeSlots": ["A-05", "A-06", "A-07", "A-08", "A-09", "A-10"],
        "lastUpdated": 814909188.0
    }
    upload_document(project_id, "queues", "Room 204", queue_data, token)
    print("   ✓ Seeded: Room 204 (Token A-07 · In Examination)")

    # 3. Seed Clinics (Attempt)
    with open(CLINICS_PATH, "r") as f:
        clinics = json.load(f)
    print(f"\n🏥 Seeding {len(clinics)} Colombo healthcare centers...")
    for clinic in clinics:
        clinic_id = clinic.get("id")
        name = clinic.get("name")
        city = clinic.get("city")
        try:
            upload_document(project_id, "clinics", clinic_id, clinic, token)
            print(f"   ✓ Seeded: {name} ({city})")
        except urllib.error.HTTPError as e:
            if e.code == 403:
                print(f"   ℹ️ Clinic '{name}' skipped (Firestore rule requires write permission on /clinics/)")
            else:
                raise

    print("\n🎉 Doctor details & Live Queues are LIVE in Cloud Firestore!")
    print(f"👉 Check your Firebase Console: https://console.firebase.google.com/project/{project_id}/firestore/databases/-default-/data")

if __name__ == "__main__":
    main()
