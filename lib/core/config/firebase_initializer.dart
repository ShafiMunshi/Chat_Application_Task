import 'package:chat_application_task/firebase_options_prod.dart';
import 'package:chat_application_task/firebase_options_staging.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options_dev.dart';
import 'environment.dart';

class FirebaseInitializer {
  static Future<void> init() async {
    switch (Env.environment) {
      case Environment.dev:
        await Firebase.initializeApp(
          options: DefaultFirebaseOptionsDev.currentPlatform,
        );
        break;

      case Environment.staging:
        await Firebase.initializeApp(
          options: DefaultFirebaseOptionsStaging.currentPlatform,
        );
        break;

      case Environment.prod:
        await Firebase.initializeApp(
          options: DefaultFirebaseOptionsProd.currentPlatform,
        );
        break;
    }
  }
}
