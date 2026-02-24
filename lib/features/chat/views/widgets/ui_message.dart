

enum MessageStatus { pending, sent, failed }

enum MessageType { text, system }

class UiMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;

  const UiMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
  });

  UiMessage copyWith({
    String? id,
    String? text,
    bool? isMe,
    DateTime? timestamp,
    MessageStatus? status,
    MessageType? type,
  }) {
    return UiMessage(
      id:        id        ?? this.id,
      text:      text      ?? this.text,
      isMe:      isMe      ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      status:    status    ?? this.status,
      type:      type      ?? this.type,
    );
  }
}

// ── Mock data for UI development / Storybook-style preview ──────────────────
final kMockMessages = <UiMessage>[
  UiMessage(
    id: '1',
    text: 'Hey! Are you free to hop on a call later today?',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '2',
    text: 'Yeah, totally! What time works for you?',
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '3',
    text: 'How about 3 PM? We can go over the new design specs.',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 38)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '4',
    text: 'Perfect, I\'ll send you the Figma link before then. There are a few screens I\'m not 100% happy with yet.',
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '5',
    text: 'No worries, we can iterate together. The chat bubble layout is looking really clean though!',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '6',
    text: 'Thanks! I spent a lot of time on the responsive spacing.',
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '7',
    text: 'It shows. See you at 3!',
    isMe: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    status: MessageStatus.sent,
  ),
  UiMessage(
    id: '8',
    text: 'This message is still being sent...',
    isMe: true,
    timestamp: DateTime.now().subtract(const Duration(seconds: 10)),
    status: MessageStatus.pending,
  ),
];