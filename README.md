# Elimu AI — Flutter App

AI study companion for Kenyan students: chat, photo/homework analysis, document reading, and quiz generation. Talks to the Express backend in `../backend` — never calls Groq/Cloudinary directly.

## Setup

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api   # Android emulator
# iOS simulator / real device: use your machine's LAN IP or deployed Railway URL instead of 10.0.2.2
```

## Structure

```
lib/
  core/
    constants/     app_constants.dart   (API base URL, storage keys)
    network/       api_client.dart      (Dio + JWT interceptor)
    router/        app_router.dart      (go_router + bottom nav shell + auth redirect)
    theme/         app_theme.dart
  features/
    auth/          login/register screens + Riverpod auth provider
    chat/          main AI chat — text + camera/gallery photo analysis
    documents/      upload PDFs/images for RAG-backed Q&A
    quiz/           generate + take practice quizzes
    progress/       placeholder — wire to a progress-summary endpoint
    profile/        logout, settings placeholder
```

## What's implemented vs. stubbed

**Implemented and wired to real backend calls:**
- Register/login/JWT persistence (flutter_secure_storage)
- Chat (study mode vs quick-answer mode toggle)
- Camera/gallery photo capture → `/api/ai/vision`
- Document upload → `/api/ai/document`
- Quiz generation + scoring → `/api/ai/quiz/generate`

**Left as clearly-marked next steps (v1.1):**
- On-device OCR fallback (`google_mlkit_text_recognition` is in `pubspec.yaml` but not yet wired into a screen — useful for scanning handwriting before sending to vision API to save Groq calls)
- Document picker inside the Quiz screen (currently accepts pasted text/topic; swap in a document list + picker once a `GET /api/ai/documents` list endpoint exists)
- Voice input/TTS (`speech_to_text` / `flutter_tts` packages included, not yet wired to a screen)
- Progress dashboard charts
- Push notifications (study reminders)
- Dark mode toggle wiring (theme exists, switch in Profile is currently inert)

## Building for release

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-app.up.railway.app/api
flutter build ios --release --dart-define=API_BASE_URL=https://your-app.up.railway.app/api
```
