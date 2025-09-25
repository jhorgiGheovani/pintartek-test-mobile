# Video Player Pintartek

Flutter video player app yang fetch video links dan titles dari backend API menggunakan BLoC state management.

## Features

- 📱 Video list dengan thumbnail dan info
- 🎥 Full-screen video player dengan controls
- 🔄 Pull-to-refresh untuk update video list
- 🎯 BLoC state management pattern
- 🌐 HTTP API integration ready
- 📐 Responsive design

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio/VS Code
- Device atau emulator untuk testing

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

## API Integration

Untuk connect ke backend API lo, update `VideoService` di `lib/services/video_service.dart`:

1. Ganti `baseUrl` dengan URL backend lo
2. Uncomment kode API calls
3. Comment bagian mock data

Expected API format:

### GET /api/videos
```json
[
  {
    "id": "1",
    "title": "Video Title",
    "videoUrl": "https://example.com/video.mp4",
    "description": "Video description",
    "thumbnailUrl": "https://example.com/thumb.jpg",
    "duration": 120
  }
]
```

### GET /api/videos/:id
```json
{
  "id": "1",
  "title": "Video Title", 
  "videoUrl": "https://example.com/video.mp4",
  "description": "Video description",
  "thumbnailUrl": "https://example.com/thumb.jpg",
  "duration": 120
}
```

## Dependencies

- `flutter_bloc` - State management
- `video_player` - Video playback
- `http` - API requests
- `equatable` - Value equality
- `json_annotation` - JSON serialization

## Usage

1. App akan show list video dari backend
2. Tap video card untuk play video
3. Video player support:
   - Play/pause
   - Seek forward/backward (10s)
   - Fullscreen mode
   - Progress indicator
   - Duration display

## Development

Untuk development, app ini pake mock data. Real API integration tinggal:

1. Setup backend API
2. Update `VideoService` 
3. Test dengan real data

## Contributing

1. Fork project
2. Create feature branch
3. Commit changes
4. Push ke branch
5. Create Pull Request
