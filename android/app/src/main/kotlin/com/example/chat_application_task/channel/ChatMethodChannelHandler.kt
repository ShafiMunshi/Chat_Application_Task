package com.example.chat_application_task.channel

import android.util.Log
import com.example.chat_application_task.models.MessageModel
import com.example.chat_application_task.service.ChatService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ChatMethodChannelHandler(
    private val chatService: ChatService,
) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.chat/channel"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d("FlutterChannel", "Message received from Flutter - Method: ${call.method}, Arguments: ${call.arguments}")
        when (call.method) {
            "sendMessage" -> handleSendMessage(call, result)
            else       -> result.notImplemented()
        }
    }

    private fun handleSendMessage(call: MethodCall, result: MethodChannel.Result) {

        @Suppress("UNCHECKED_CAST")
        val messageData = call.arguments as? Map<String, Any>
        if (messageData == null || MessageModel.isAnyDataMissing(messageData)) {
            result.error("INVALID_ARG", "Missing information of Message Data", null)
            return
        }

        val message = MessageModel.fromMap(messageData)
        val chatId = message.chatId
        chatService.sendMessage(
            chatId = chatId,
            messageData = messageData,
            onSuccess = { result.success(null) },
            onError = { e -> result.error("FIRESTORE_ERROR", e.localizedMessage, null) }
        )
    }


}
