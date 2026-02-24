import 'package:chat_application_task/features/auth/views/provider/auth_provider.dart';
import 'package:chat_application_task/features/auth/views/provider/sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              ref.read(signOutProvider);
            }, child:  Text('Logout')),
            Text('Welcome to the Chat Screen!'),
          ],
        ),
      ),
    );
  }
}