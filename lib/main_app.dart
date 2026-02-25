import 'package:chat_application_task/core/routes/route.dart';
import 'package:chat_application_task/core/config/themes/app_theme.dart';
import 'package:chat_application_task/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    // return MaterialApp.router(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: AppTheme.dark,
    //   routerConfig: router,
    // );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dark,
      home: TestScreen()
    );
  }
}
