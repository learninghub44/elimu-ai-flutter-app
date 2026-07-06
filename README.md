# Elimu AI — Flutter App

![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.3-02569B?logo=flutter)
[![CI](https://github.com/learninghub44/elimu-ai-flutter-app/actions/workflows/ci.yml/badge.svg)](https://github.com/learninghub44/elimu-ai-flutter-app/actions/workflows/ci.yml)
![License](https://img.shields.io/badge/license-MIT-blue)

AI study companion for Kenyan students — chat, homework/photo analysis, document reading, and quiz generation. Talks exclusively to the [Elimu AI backend](https://github.com/learninghub44/elimu-ai-backend); never calls Groq or Cloudinary directly.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [What's Implemented vs. Roadmap](#whats-implemented-vs-roadmap)
- [Building for Release](#building-for-release)
- [Contributing](#contributing)
- [License](#license)

## Features

- 🔐 Secure registration/login with JWT persisted via `flutter_secure_storage`
- 💬 AI chat with a **Study mode** (guided reasoning) and **Quick answer mode**
- 📷 Camera/gallery capture → AI photo analysis (homework, textbook pages, diagrams)
- 📄 Document upload (PDF/image) feeding a RAG-backed Q&A pipeline
- 📝 AI-generated practice quizzes with instant scoring
- 🌓 Light/dark theme foundation

## Tech Stack

| Concern | Package |
|---|---|
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| Networking | `dio` |
| Camera / gallery | `camera`, `image_picker`, `image_cropper` |
| Documents | `file_picker`, `syncfusion_flutter_pdfviewer` |
| OCR (planned) | `google_mlkit_text_recognition` |
| Chat rendering | `flutter_markdown` |
| Voice (planned) | `speech_to_text`, `flutter_tts` |
| Local storage | `hive`, `flutter_secure_storage` |

## Project Structure

```
lib/
  core/
    constants/     app_constants.dart   — API base URL, storage keys
    network/       api_client.dart      — Dio + JWT interceptor, error normalization
    router/        app_router.dart      — go_router + bottom nav shell + auth redirect
    theme/         app_theme.dart
  features/
    auth/          login/register screens + Riverpod auth provider
    chat/          core AI chat — text + camera/gallery photo analysis
    documents/     upload PDFs/images for RAG-backed Q&A
    quiz/          generate + take practice quizzes
    progress/      placeholder — wire to a progress-summary endpoint
    profile/       logout, settings placeholder
```

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.3 (`flutter --version`)
- A running instance of [`elimu-ai-backend`](https://github.com/learninghub44/elimu-ai-backend)

### Installation

```bash
git clone https://github.com/learninghub44/elimu-ai-flutter-app.git
cd elimu-ai-flutter-app
flutter pub get
```

### Run against a local backend

```bash
# Android emulator (10.0.2.2 maps to your machine's localhost)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api

# iOS simulator / physical device — use your LAN IP or deployed URL instead
flutter run --dart-define=API_BASE_URL=https://your-app.up.railway.app/api
```

## What's Implemented vs. Roadmap

**Implemented, wired to real backend calls:**
- Register/login/JWT persistence
- Chat with study/quick mode toggle
- Camera/gallery photo analysis → `/api/ai/vision`
- Document upload → `/api/ai/document`
- Quiz generation + scoring → `/api/ai/quiz/generate`

**Roadmap (v1.1):**
- [ ] On-device OCR fallback before sending images to the vision API (package already included)
- [ ] Document picker in the Quiz screen (needs a `GET /api/ai/documents` list endpoint)
- [ ] Voice input / text-to-speech (packages included, not yet wired)
- [ ] Progress dashboard with charts
- [ ] Push notifications for study reminders
- [ ] Dark mode toggle wired to a persisted theme provider

## Building for Release

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-app.up.railway.app/api
flutter build ios --release --dart-define=API_BASE_URL=https://your-app.up.railway.app/api
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for workflow, commit conventions, and code style.

## License

[MIT](./LICENSE) © Chris (learninghub44)
