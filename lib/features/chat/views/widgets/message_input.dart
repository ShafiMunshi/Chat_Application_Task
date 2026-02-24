import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onMicTap;
  final bool isListening;
  final TextEditingController controller;

  const MessageInputBar({
    super.key,
    required this.onSend,
    required this.onMicTap,
    required this.isListening,
    required this.controller,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar>
    with SingleTickerProviderStateMixin {
  bool _hasText = false;

  // Pulse animation for listening state
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.22,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(MessageInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      widget.isListening ? _pulseCtrl.repeat(reverse: true) : _pulseCtrl.stop();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    widget.onSend(text);
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _InputField(controller: widget.controller)),

              SizedBox(width: 8.w),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: !_hasText
                    ? _MicButton(
                        key: const ValueKey('mic'),
                        isListening: widget.isListening,
                        pulseAnim: _pulseAnim,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          widget.onMicTap();
                        },
                      )
                    : const SizedBox.shrink(key: ValueKey('mic_hidden')),
              ),

              // ── Send Button ─────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: _hasText
                    ? _SendButton(
                        key: const ValueKey('send'),
                        onTap: _handleSend,
                      )
                    : const SizedBox.shrink(key: ValueKey('send_hidden')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Input Field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  const _InputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 44.h,
        maxHeight: 120.h, // ~4-5 lines before scroll kicks in
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        child: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.messageHint,
            hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textMuted),
            border: InputBorder.none,
            // Vertically centers single-line text
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            isDense: true,
          ),
          cursorColor: AppColors.accent,
          cursorWidth: 2,
          cursorRadius: const Radius.circular(1),
        ),
      ),
    );
  }
}

// ── Mic Button ───────────────────────────────────────────────────────────────

class _MicButton extends StatelessWidget {
  final bool isListening;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;

  const _MicButton({
    super.key,
    required this.isListening,
    required this.pulseAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: pulseAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isListening
                ? AppColors.error.withOpacity(0.15)
                : AppColors.inputBackground,
            border: Border.all(
              color: isListening ? AppColors.error : AppColors.divider,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Icon(
              isListening ? Icons.stop_rounded : Icons.mic_rounded,
              size: 20.r,
              color: isListening ? AppColors.error : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Send Button ───────────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.bubbleGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(Icons.send_rounded, size: 18.r, color: Colors.white),
        ),
      ),
    );
  }
}

// ── STT Listening Banner ──────────────────────────────────────────────────────
// Shown above the input bar when STT is active.

class SttListeningBanner extends StatefulWidget {
  final bool isVisible;
  const SttListeningBanner({super.key, required this.isVisible});

  @override
  State<SttListeningBanner> createState() => _SttListeningBannerState();
}

class _SttListeningBannerState extends State<SttListeningBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    if (widget.isVisible) _ctrl.forward();
  }

  @override
  void didUpdateWidget(SttListeningBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.isVisible ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SizeTransition(
        sizeFactor: _fadeAnim,
        child: Container(
          width: double.infinity,
          color: AppColors.error.withOpacity(0.08),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              _WaveformIndicator(),
              SizedBox(width: 10.w),
              Text(
                AppStrings.listeningNow,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaveformIndicator extends StatefulWidget {
  @override
  State<_WaveformIndicator> createState() => _WaveformIndicatorState();
}

class _WaveformIndicatorState extends State<_WaveformIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(4, (i) {
            final height = 4.0 + 10.0 * (((_ctrl.value + i * 0.25) % 1.0));
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.5.w),
              width: 3.w,
              height: height.h,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(2.r),
              ),
            );
          }),
        );
      },
    );
  }
}
