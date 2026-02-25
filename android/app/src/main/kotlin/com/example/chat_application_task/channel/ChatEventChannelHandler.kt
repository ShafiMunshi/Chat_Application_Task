package com.example.chat_application_task.channel

import com.example.chat_application_task.service.ChatService
import com.google.firebase.firestore.ListenerRegistration
import io.flutter.plugin.common.EventChannel

class ChatEventChannelHandler(
    private val chatService: ChatService,
) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.chat/messages"
    }

    private var listenerRegistration: ListenerRegistration? = null
    private var activeSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val chatId = (arguments as? Map<*, *>)?.get("chatId") as? String
        if (chatId == null) {
            events.error("INVALID_ARG", "chatId is required", null)
            return
        }

        // Tear down previous subscription before opening a new one.
        listenerRegistration?.remove()
        listenerRegistration = null
        activeSink = events

        listenerRegistration = chatService.listenForMessages(
            chatId = chatId,
            onUpdate = { messages ->
                try {
                    activeSink?.success(messages.map { HashMap(it) })
                } catch (_: Exception) { /* sink terminated — ignore */ }
            },
            onError = { e ->
                try {
                    activeSink?.error("FIRESTORE_ERROR", e.message, null)
                } catch (_: Exception) { /* sink terminated — ignore */ }
            },
        )
    }

    override fun onCancel(arguments: Any?) {
        activeSink = null          // mark sink as dead before removing listener
        listenerRegistration?.remove()
        listenerRegistration = null
    }
}
