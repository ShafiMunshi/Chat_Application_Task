package com.example.chat_application_task

import com.example.chat_application_task.channel.ChatEventChannelHandler
import com.example.chat_application_task.channel.ChatMethodChannelHandler
import com.example.chat_application_task.service.ChatService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val chatService = ChatService()

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ChatMethodChannelHandler.CHANNEL_NAME,
        )
        methodChannel.setMethodCallHandler(ChatMethodChannelHandler(chatService))

        eventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ChatEventChannelHandler.CHANNEL_NAME,
        )
        eventChannel.setStreamHandler(ChatEventChannelHandler(chatService))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }
}
