import 'package:chat_application_task/core/config/firebase_initializer.dart';
import 'package:chat_application_task/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await FirebaseInitializer.init();

  runApp(const ProviderScope(child: MainApp()));
}
