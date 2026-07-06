class ChatMessage {
  final String role; // 'user' | 'assistant'
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  ChatMessage({
    required this.role,
    required this.content,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isUser => role == 'user';
}
