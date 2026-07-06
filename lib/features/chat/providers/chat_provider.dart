import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/chat_message.dart';

enum StudyMode { study, quick }

class ChatState {
  final List<ChatMessage> messages;
  final bool isSending;
  final String? conversationId;
  final StudyMode mode;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.conversationId,
    this.mode = StudyMode.study,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? conversationId,
    StudyMode? mode,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      conversationId: conversationId ?? this.conversationId,
      mode: mode ?? this.mode,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  final _api = ApiClient.instance;

  void setMode(StudyMode mode) => state = state.copyWith(mode: mode);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(role: 'user', content: text);
    state = state.copyWith(messages: [...state.messages, userMessage], isSending: true, error: null);

    try {
      final res = await _api.dio.post('/ai/chat', data: {
        'conversationId': state.conversationId,
        'message': text,
        'mode': state.mode == StudyMode.quick ? 'quick' : 'study',
      });

      final reply = ChatMessage(role: 'assistant', content: res.data['reply']);
      state = state.copyWith(
        messages: [...state.messages, reply],
        isSending: false,
        conversationId: res.data['conversationId'],
      );
    } on DioException catch (e) {
      state = state.copyWith(isSending: false, error: e.error?.toString() ?? 'Failed to send message');
    }
  }

  /// Analyze a photo (homework, textbook page, diagram) with an optional question.
  Future<void> analyzePhoto(File imageFile, {String? question}) async {
    state = state.copyWith(isSending: true, error: null);

    final userMessage = ChatMessage(
      role: 'user',
      content: question ?? 'Explain this image',
      imageUrl: imageFile.path,
    );
    state = state.copyWith(messages: [...state.messages, userMessage]);

    try {
      final formData = FormData.fromMap({
        'question': question,
        'mode': state.mode == StudyMode.quick ? 'quick' : 'study',
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final res = await _api.dio.post('/ai/vision', data: formData);

      final reply = ChatMessage(role: 'assistant', content: res.data['answer']);
      state = state.copyWith(messages: [...state.messages, reply], isSending: false);
    } on DioException catch (e) {
      state = state.copyWith(isSending: false, error: e.error?.toString() ?? 'Failed to analyze photo');
    }
  }

  void reset() => state = const ChatState();
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
