package com.example.chat_application_task

import com.example.chat_application_task.channel.ChatMethodChannelHandler
import com.example.chat_application_task.firestore.FirestoreService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ChatMethodChannelHandler.CHANNEL_NAME,
        ).setMethodCallHandler(ChatMethodChannelHandler(FirestoreService()))
    }
}
