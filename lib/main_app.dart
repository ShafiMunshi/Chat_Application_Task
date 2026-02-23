import 'package:chat_application_task/core/routes/route.dart';
import 'package:chat_application_task/features/auth/views/screens/sign_in_screen.dart';
import 'package:chat_application_task/features/auth/views/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: ref.read(goRouterProvider),
    );
  }
}
