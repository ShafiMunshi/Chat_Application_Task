import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String? avatarUrl;

  const ChatAppBar({
    super.key,
    required this.userName,
    this.avatarUrl,

  });

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            // Back Button
            _AppBarIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),

            SizedBox(width: 4.w),

            // Avatar with online indicator
            GestureDetector(
              onTap: () => print('Avatar tapped'),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.avatarGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _AvatarPlaceholder(name: userName),
                            ),
                          )
                        : _AvatarPlaceholder(name: userName),
                  ),

                  // // Online dot
                  // if (isOnline)
                  //   Positioned(
                  //     right: 0,
                  //     bottom: 0,
                  //     child: Container(
                  //       width: 11.r,
                  //       height: 11.r,
                  //       decoration: BoxDecoration(
                  //         color: AppColors.online,
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //           color: AppColors.surface,
                  //           width: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            // Name & status
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  // _OnlineStatusText(isOnline: isOnline),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  final String name;
  const _AvatarPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _OnlineStatusText extends StatelessWidget {
  final bool isOnline;
  const _OnlineStatusText({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isOnline) ...[
          Container(
            width: 5.r,
            height: 5.r,
            decoration: const BoxDecoration(
              color: AppColors.online,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          isOnline ? AppStrings.activeNow : AppStrings.offline,
          style: TextStyle(
            fontSize: 11.sp,
            color: isOnline ? AppColors.online : AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _AppBarIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, size: 20.r, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
