import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application_task/features/chat/views/widgets/ui_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final UiMessage message;
  final bool showDateDivider;
  final bool showAvatar;
  final bool isLastInGroup;

  const ChatBubble({
    super.key,
    required this.message,
    this.showDateDivider = false,
    this.showAvatar = false,
    this.isLastInGroup = true,
  });

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.system) {
      return _SystemMessageBubble(text: message.text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDateDivider) _DateDivider(date: message.timestamp),
        _BubbleRow(
          message: message,
          showAvatar: showAvatar,
          isLastInGroup: isLastInGroup,
        ),
      ],
    );
  }
}

// ── Bubble Row ───────────────────────────────────────────────────────────────

class _BubbleRow extends StatelessWidget {
  final UiMessage message;
  final bool showAvatar;
  final bool isLastInGroup;

  const _BubbleRow({
    required this.message,
    required this.showAvatar,
    required this.isLastInGroup,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 60.w : 12.w,
        right: isMe ? 12.w : 60.w,
        bottom: isLastInGroup ? 8.h : 2.h,
      ),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (other user only)
          if (!isMe) ...[_BubbleAvatar(show: showAvatar), SizedBox(width: 6.w)],

          // Bubble content
          Flexible(child: _BubbleContent(message: message)),

          // Status indicator (own messages only, at end)
          if (isMe) ...[
            SizedBox(width: 4.w),
            _StatusIcon(status: message.status),
          ],
        ],
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final UiMessage message;
  const _BubbleContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    // Bubble radius: squared corner on the "tail" side
    final radius = BorderRadius.only(
      topLeft: Radius.circular(18.r),
      topRight: Radius.circular(18.r),
      bottomLeft: isMe ? Radius.circular(18.r) : Radius.circular(4.r),
      bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(18.r),
    );

    return AnimatedOpacity(
      opacity: message.status == MessageStatus.pending ? 0.65 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: isMe ? AppColors.bubbleGradient : null,
          color: isMe ? null : AppColors.bubbleSurface,
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? AppColors.accent.withOpacity(0.18)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Message text
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.45,
                  color: isMe ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 4.h),

              // Timestamp row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isMe
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── Avatar ───────────────────────────────────────────────────────────────────

class _BubbleAvatar extends StatelessWidget {
  final bool show;
  const _BubbleAvatar({required this.show});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.r,
      height: 28.r,
      child: show
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.avatarGradient,
              ),
              child: Center(
                child: Icon(Icons.person, size: 14.r, color: Colors.white),
              ),
            )
          : null, // keeps spacing when avatar is hidden (grouped messages)
    );
  }
}

// ── Status Icon ──────────────────────────────────────────────────────────────

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      MessageStatus.pending => _PendingSpinner(),
      MessageStatus.sent => Icon(
        Icons.done_all_rounded,
        size: 14.r,
        color: AppColors.accent.withOpacity(0.8),
      ),
      MessageStatus.failed => Icon(
        Icons.error_outline_rounded,
        size: 14.r,
        color: AppColors.error,
      ),
    };
  }
}

class _PendingSpinner extends StatefulWidget {
  @override
  State<_PendingSpinner> createState() => _PendingSpinnerState();
}

class _PendingSpinnerState extends State<_PendingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Icon(
        Icons.access_time_rounded,
        size: 13.r,
        color: AppColors.textMuted,
      ),
    );
  }
}

// ── Date Divider ─────────────────────────────────────────────────────────────

class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return AppStrings.today;
    if (d == today.subtract(const Duration(days: 1)))
      return AppStrings.yesterday;
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              _label(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        ],
      ),
    );
  }
}

// ── System Message ────────────────────────────────────────────────────────────

class _SystemMessageBubble extends StatelessWidget {
  final String text;
  const _SystemMessageBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 40.w),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.bubbleSurface,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
