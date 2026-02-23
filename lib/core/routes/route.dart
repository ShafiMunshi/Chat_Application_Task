import 'package:flutter/material.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case '/sign-in':
    //   return MaterialPageRoute(builder: (_) => SignInScreen());
    // case '/sign-up':
    //   return MaterialPageRoute(builder: (_) => SignUpScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}