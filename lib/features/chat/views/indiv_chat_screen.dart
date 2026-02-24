import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/features/chat/views/widgets/chat_app_bar.dart';
import 'package:chat_application_task/features/chat/views/widgets/chat_bubble.dart';
import 'package:chat_application_task/features/chat/views/widgets/message_input.dart';
import 'package:chat_application_task/features/chat/views/widgets/ui_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndivChatScreen extends StatefulWidget {
  final List<UiMessage> messages;
  final String userName;
  final String? avatarUrl;
  final bool isOnline;
  final bool isListening;
  final bool hasInternet;

  final ValueChanged<String> onSend;
  final VoidCallback onMicTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onMoreTap;

  const IndivChatScreen({
    super.key,
    required this.messages,
    required this.userName,
    required this.onSend,
    required this.onMicTap,
    this.avatarUrl,
    this.isOnline = false,
    this.isListening = false,
    this.hasInternet = true,
    this.onBackTap,
    this.onAvatarTap,
    this.onMoreTap,
  });

  @override
  State<IndivChatScreen> createState() => _IndivChatScreenState();
}

class _IndivChatScreenState extends State<IndivChatScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _inputController;
  late final ScrollController _scrollController;

  // Track keyboard visibility to re-scroll when keyboard appears
  double _previousBottomInset = 0;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _scrollController = ScrollController();
    // WidgetsBindingObserver.prototype;
    WidgetsBinding.instance.addObserver(this);

    // Scroll to bottom on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(IndivChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // New message arrived → scroll to bottom
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    // STT transcription result arrived → fill the input field
    // (The parent should update the controller text externally)
    // Alternatively, the parent can use a TextEditingController it owns and
    // pass it down — here we just accept controller mutation from outside.

    // Internet state changed
    if (widget.hasInternet != oldWidget.hasInternet) {
      if (!widget.hasInternet) {
        // NoInternetDialog.show(context);
      } else {
        // NoInternetDialog.dismiss();
        // ReconnectedSnackbar.show(context);
      }
    }
  }

  @override
  void didChangeMetrics() {
    // Keyboard appeared → scroll to bottom
    final bottomInset = WidgetsBinding
        .instance
        .platformDispatcher
        .views
        .first
        .viewInsets
        .bottom;
    if (bottomInset > _previousBottomInset) {
      _previousBottomInset = bottomInset;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } else {
      _previousBottomInset = bottomInset;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inputController.dispose();
    _scrollController.dispose();
    // NoInternetDialog.dismiss();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    if (animate) {
      _scrollController.animateTo(
        max,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(max);
    }
  }

  void _handleSend(String text) {
    widget.onSend(text);
    // Optimistic scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are on a tablet
    final isTablet = 1.sw > 600;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ChatAppBar(
          userName: widget.userName,
          avatarUrl: widget.avatarUrl,
          isOnline: widget.isOnline,
          onBackTap: widget.onBackTap,
          onAvatarTap: widget.onAvatarTap,
          onMoreTap: widget.onMoreTap,
        ),
        body: Column(
          children: [
            // ── Offline Banner (inline top strip) ───────────────────────
            _OfflineBanner(visible: !widget.hasInternet),

            // ── Message List ─────────────────────────────────────────────
            Expanded(
              child: _MessageList(
                messages: widget.messages,
                scrollController: _scrollController,
                isTablet: isTablet,
              ),
            ),

            // ── STT Listening Banner ─────────────────────────────────────
            SttListeningBanner(isVisible: widget.isListening),

            // ── Input Bar ────────────────────────────────────────────────
            MessageInputBar(
              controller: _inputController,
              isListening: widget.isListening,
              onSend: _handleSend,
              onMicTap: widget.onMicTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Message List ──────────────────────────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final List<UiMessage> messages;
  final ScrollController scrollController;
  final bool isTablet;

  const _MessageList({
    required this.messages,
    required this.scrollController,
    required this.isTablet,
  });

  // Group consecutive messages from the same sender so we only show
  // the avatar on the last bubble in a group.
  List<_BubbleConfig> _buildConfigs() {
    final configs = <_BubbleConfig>[];

    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final prev = i > 0 ? messages[i - 1] : null;
      final next = i < messages.length - 1 ? messages[i + 1] : null;

      // final isFirstInGroup = prev == null || prev.isMe != msg.isMe;
      final isLastInGroup = next == null || next.isMe != msg.isMe;

      // Show date divider when date changes
      final showDivider =
          prev == null || !_isSameDay(prev.timestamp, msg.timestamp);

      configs.add(
        _BubbleConfig(
          message: msg,
          showDateDivider: showDivider,
          showAvatar: isLastInGroup && !msg.isMe,
          isLastInGroup: isLastInGroup,
        ),
      );
    }

    return configs;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return _EmptyState();

    final configs = _buildConfigs();

    // On tablet: add horizontal padding so chat doesn't stretch full-width
    final horizontalPad = isTablet ? 0.15.sw : 0.0;

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: 8.h,
        left: horizontalPad,
        right: horizontalPad,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: configs.length,
      itemBuilder: (_, i) {
        final cfg = configs[i];
        return ChatBubble(
          message: kMockMessages[i],
          showDateDivider: cfg.showDateDivider,
          showAvatar: cfg.showAvatar,
          isLastInGroup: cfg.isLastInGroup,
        );
      },
    );
  }
}

class _BubbleConfig {
  final UiMessage message;
  final bool showDateDivider;
  final bool showAvatar;
  final bool isLastInGroup;

  const _BubbleConfig({
    required this.message,
    required this.showDateDivider,
    required this.showAvatar,
    required this.isLastInGroup,
  });
}

// ── Offline Banner ────────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  final bool visible;
  const _OfflineBanner({required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: visible ? 36.h : 0,
      color: AppColors.error.withOpacity(0.12),
      child: visible
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 13.r,
                  color: AppColors.error,
                ),
                SizedBox(width: 6.w),
                Text(
                  AppStrings.noInternetQueued,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 48.r,
            color: AppColors.textMuted,
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.noMessagesYet,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppStrings.startConversation,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ── Preview / Storybook entry point ──────────────────────────────────────────
// Use this to run the chat screen in isolation without any backend.

class ChatScreenPreview extends StatefulWidget {
  const ChatScreenPreview({super.key});

  @override
  State<ChatScreenPreview> createState() => _ChatScreenPreviewState();
}

class _ChatScreenPreviewState extends State<ChatScreenPreview> {
  List<UiMessage> _messages = List.from(kMockMessages);
  bool _isListening = false;
  bool _hasInternet = true;

  void _handleSend(String text) {
    setState(() {
      _messages = [
        ..._messages,
        UiMessage(
          id: DateTime.now().toIso8601String(),
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
          status: MessageStatus.sent,
        ),
      ];
    });
  }

  void _toggleMic() => setState(() => _isListening = !_isListening);

  void _toggleInternet() => setState(() => _hasInternet = !_hasInternet);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndivChatScreen(
            messages: _messages,
            userName: 'Alice Chen',
            isOnline: true,
            isListening: _isListening,
            hasInternet: _hasInternet,
            onSend: _handleSend,
            onMicTap: _toggleMic,
          ),
          // Dev-only toggle buttons
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'net',
                  backgroundColor: _hasInternet ? Colors.green : Colors.red,
                  onPressed: _toggleInternet,
                  child: Icon(_hasInternet ? Icons.wifi : Icons.wifi_off),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
