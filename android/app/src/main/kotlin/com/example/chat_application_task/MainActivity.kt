package com.example.chat_application_task

import com.example.chat_application_task.channel.ChatMethodChannelHandler
import com.example.chat_application_task.service.ChatService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

     private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ChatMethodChannelHandler.CHANNEL_NAME,
        )
        methodChannel.setMethodCallHandler(ChatMethodChannelHandler(ChatService()))
    }
    
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        methodChannel.setMethodCallHandler(null)
    }
}
