# Contributing to Elimu AI (Flutter)

## Development workflow

1. Fork and clone the repo.
2. Run `flutter pub get`.
3. Create a feature branch: `git checkout -b feature/your-feature-name`.
4. Point the app at a local backend: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api`
   (see the backend repo: https://github.com/learninghub44/elimu-ai-backend)
5. Keep commits scoped and use Conventional Commits style (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`).
6. Run `flutter analyze` and `flutter test` before opening a PR.
7. Open a PR against `main` describing what changed and why.

## Code style

- State management: Riverpod (`StateNotifierProvider`) — keep this consistent across features.
- Navigation: `go_router` only — no `Navigator.push` for top-level screens.
- All network calls go through `core/network/api_client.dart` (`ApiClient.instance.dio`) so
  the JWT interceptor and error normalization are applied consistently.
- Never call Groq, Cloudinary, or any third-party API directly from Flutter — always proxy
  through the backend so API keys stay server-side.
- One feature = one folder under `lib/features/<feature>/` with `screens/`, `providers/`,
  and (if needed) `widgets/` and `models/` subfolders.

## Reporting issues

Open a GitHub issue with your Flutter/Dart version (`flutter --version`), platform
(Android/iOS), steps to reproduce, and relevant logs.
