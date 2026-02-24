import 'dart:developer';

import 'package:chat_application_task/core/splash/splash_screen.dart';
import 'package:chat_application_task/features/auth/views/provider/auth_provider.dart';
import 'package:chat_application_task/features/auth/views/screens/sign_in_screen.dart';
import 'package:chat_application_task/features/auth/views/screens/sign_up_screen.dart';
import 'package:chat_application_task/features/chat/views/chat_users_screen.dart';
import 'package:chat_application_task/features/chat/views/indiv_chat_screen.dart';
import 'package:chat_application_task/features/chat/views/widgets/ui_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthNotifier();

  // fires AFTER Riverpod has already updated authStateProvider
  ref.listen(authStateProvider, (_, __) => notifier.notify());

  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final user = auth.value;
      final isLoading = auth.isLoading;
      final hasError = auth.hasError;

      log(
        "Is loading: $isLoading, Has error: $hasError, User: $user, Location: ${state.matchedLocation}",
      );

      final goingToSignIn = state.matchedLocation == '/sign_in';
      final goingToSignUp = state.matchedLocation == '/sign_up';

      if (isLoading) return null;

      if (hasError || user == null) {
        if (goingToSignIn || goingToSignUp) return null;
        return '/sign_in';
      }

      // Authenticated - leave sign-in/sign-up/splash
      if (goingToSignIn || goingToSignUp || state.matchedLocation == '/') {
        return '/chat_users';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/sign_in', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/sign_up', builder: (_, __) => const SignUpScreen()),
      GoRoute(
        path: '/chat',
        builder: (_, __) => IndivChatScreen(
          messages: kMockMessages,
          userName: 'John Doe',
          onSend: (value) {},
          onMicTap: () {},
        ),
      ),
      GoRoute(
        path: '/chat_users',
        builder: (_, __) => const ChatUsersScreen(),
      ),
    ],
  );
});

class _AuthNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
