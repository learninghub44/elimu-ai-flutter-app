class AppConstants {
  AppConstants._();

  // Point this to your deployed Railway backend URL.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/api', // Android emulator localhost
  );

  static const String tokenStorageKey = 'elimu_ai_jwt_token';
  static const String userBoxName = 'user_box';
  static const String chatHistoryBoxName = 'chat_history_box';

  static const int maxImageUploadSizeMb = 15;
}
