## Download App

[Download APK](https://github.com/jhorgiGheovani/pintartek-test-mobile/raw/main/app-release.apk)

## Architecture

App ini menggunakan clean architecture dengan BLoC pattern:

```
lib/
├── bloc/           # BLoC files (events, states, bloc)
├── models/         # Data models
├── services/       # API services
├── screens/        # UI screens
├── widgets/        # Reusable widgets
└── main.dart       # App entry point

```

### Installation

1. Clone project ini
2. Install dependencies:
```bash
flutter pub get
```

3. Run app:
```bash
flutter run
```
