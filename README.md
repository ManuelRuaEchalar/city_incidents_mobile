# 🏙️ City Incidents App - Urban Incident Monitor

## 📄 About the Project

**City Incidents App** is a mobile application developed in Flutter designed to empower citizens in the care and maintenance of their urban environment. This tool acts as a direct bridge between the community and the authorities in charge of city maintenance.

### 🎯 The Need & The Problem
Citizens currently lack an agile and effective way to report daily infrastructure problems, such as potholes, broken streetlights, or garbage accumulation. Traditional channels are bureaucratic and slow, causing many issues to go unnoticed or take too long to resolve, leading to frustration and a decline in urban quality of life.

This application solves this problem by digitizing and simplifying the reporting process, allowing for instant visual and geolocated communication.

### ✨ Key Features

*   **📍 Geolocated Reports:** Automatic capture of the exact incident location via GPS.
*   **📸 Photographic Evidence:** Camera integration to attach real photos of the problem.
*   **Smart Categorization:** Intuitive classification of incidents (Roads, Lighting, Garbage, Traffic Lights, etc.).
*   **🗺️ Interactive Map:** Real-time visualization of all reported incidents in the city.
*   **📊 Traceability:** Tracking the status of reports (Pending, In Process, Resolved) with visual indicators.
*   **👤 User Profile:** Personal history of reports and citizen contribution statistics.

---

## 📱 Try Demo (APK)
A compiled APK file is available in the root of this repository for quick testing without setting up the development environment.

*   📅 **File:** `app-release.apk`
*   ⬇️ **Install:** Transfer the file to your Android device and install it (you may need to enable installation from unknown sources).

---

## 🚀 Installation & Execution Guide

Follow these steps to run the application in your local environment.

### Prerequisites
*   Have **Flutter SDK** installed (version compatible with 3.10+).
*   Have **Git** installed.
*   A physical Android device or a configured emulator.

### 1. Clone the Repository
Open your terminal and clone the project source code:

```bash
git clone <REPOSITORY_URL>
cd city_incidents_mobile
```
*(Note: Replace `<REPOSITORY_URL>` with your actual repo url)*

### 2. Install Dependencies
Download all necessary libraries listed in `pubspec.yaml`:

```bash
flutter pub get
```

### 3. Setup the Device
To run on an Android mobile:
1.  Connect your device to your PC via a USB cable.
2.  Ensure **Developer Options** and **USB Debugging** are enabled on your phone.
3.  Verify that your PC recognizes the device by running:
    ```bash
    flutter devices
    ```

### 4. Run the Application
Once the device is connected, launch the app with the following command:

```bash
flutter run
```

If everything is correct, the application will compile and open on your mobile device.

---

## 🛠️ Technologies Used
*   **Flutter & Dart**
*   **Provider** (State Management)
*   **Http** (REST API Connection)
*   **Flutter Map** (OpenSource Maps)
*   **Clean Architecture** (Scalable Structure)
