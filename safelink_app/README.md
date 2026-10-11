# safelink_app

Flutter mobile application for SafeLink. Users input a URL or share a link from another app, the app submits it to the backend for Gemini AI analysis, and displays a safety verdict. Safe URLs open automatically in the user's selected browser, Warning URLs open only when the user chooses to proceed, and Danger URLs are blocked.

---

## Prerequisites

| Software | Minimum Version |
|----------|----------------|
| [Flutter](https://docs.flutter.dev/get-started/install) | 3.x |
| Android SDK | API level 21+ |

To verify Flutter is installed correctly:

```bash
flutter doctor
```

Resolve any issues marked with `✗` before continuing. Items related to iOS/Xcode can be ignored if you are targeting Android only.

---

## Setup

### 1. Install Flutter dependencies

```bash
flutter pub get
```

### 2. Configure the server address

> **This step is required.** The app will not connect to the backend unless `SERVER_URL` is set correctly for your environment.

Copy `.env.example` to `.env` inside the `safelink_app/` folder and set `SERVER_URL` to match your setup:

```env
# Android emulator: use 10.0.2.2 to reach the host machine's localhost
# Physical device or external server: replace with your server's IP or domain
SERVER_URL=http://10.0.2.2:11112
```

| Scenario | Value |
|----------|-------|
| Android emulator (same machine as backend) | `http://10.0.2.2:11112` |
| Physical device on the same Wi-Fi | `http://192.168.x.x:11112` (your computer's local IP) |
| Remote server | `https://your-server-domain.com` |

To find your local IP on **Windows**: run `ipconfig` and look for `IPv4 Address`.  
To find your local IP on **macOS/Linux**: run `ifconfig` and look for `inet`.

> **Windows firewall:** If the physical device cannot reach the backend, the firewall may be blocking port `11112`. Run the following in PowerShell as Administrator:
> ```powershell
> New-NetFirewallRule -DisplayName "SafeLink Backend" -Direction Inbound -Protocol TCP -LocalPort 11112 -Action Allow
> ```

### 3. Run the app

Connect an Android device via USB (with USB debugging enabled) or start an Android emulator, then:

```bash
flutter run
```

To list available devices:

```bash
flutter devices
```

To target a specific device:

```bash
flutter run -d <device_id>
```

---

## Directory Structure

```
safelink_app/
├── .env                        # Server URL configuration (not committed)
├── lib/
│   ├── main.dart               # App entry point
│   ├── components/             # Reusable UI widgets
│   ├── const/                  # Colors, theme, and constant names
│   ├── screens/                # Application screens
│   ├── services/               # API client and local data management
│   └── utils/                  # Utility functions
├── assets/
│   ├── logo.png / logo.svg / 404_logo.svg
│   ├── animations/             # Lottie animation files
│   └── i18n/                   # Localization JSON files (English)
├── android/                    # Android platform configuration
└── pubspec.yaml                # Flutter package dependencies
```

---

## Screens

| Screen | Description |
|--------|-------------|
| `splash_screen.dart` | Initial screen for username registration / login |
| `home_screen.dart` | URL input and deep-link entry point |
| `result_screen.dart` | Displays AI analysis verdict; tap the URL to expand or collapse the full address |
| `log_screen.dart` | History of previously analyzed URLs; tap any entry to expand or collapse the full address |
| `setting_screen.dart` | App settings (browser selection, scan history toggle, auto-open toggle) |
| `setting_browser_screen.dart` | Select which browser to use after a scan |

---

## Services

| File | Description |
|------|-------------|
| `safelink_service.dart` | HTTP client for all backend API calls |
| `local_data_manager.dart` | SharedPreferences-based local storage with versioned migration |
| `localization_service.dart` | Loads and serves localized strings from `assets/i18n/` |
| `platform_channel_service.dart` | Native Android calls for browser listing and URL launching |

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_dotenv` | Loads server URL from `.env` at runtime |
| `http` | Backend API communication |
| `shared_preferences` | Local data persistence |
| `app_links` | Deep link handling |
| `lottie` | Loading animation |
| `flutter_svg` | SVG asset rendering |
| `url_launcher` | Opens URLs in the selected browser |
| `fluttertoast` | Toast notification messages |
