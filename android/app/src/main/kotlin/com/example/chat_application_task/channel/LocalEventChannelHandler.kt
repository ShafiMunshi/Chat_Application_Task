package com.example.chat_application_task.channel

import com.example.chat_application_task.models.MessageModel
import com.example.chat_application_task.service.SyncManager
import io.flutter.plugin.common.EventChannel

class LocalEventChannelHandler(
    private val syncManager: SyncManager,
) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.chat/local_messages"
    }

    private var activeSink: EventChannel.EventSink? = null
    private var cancelHandler: (() -> Unit)? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val chatId = (arguments as? Map<*, *>)?.get("chatId") as? String
        if (chatId == null) {
            events.error("INVALID_ARG", "chatId is required", null)
            return
        }

        // Cancel any previous subscription (handles hot restart ordering)
        cancelHandler?.invoke()
        activeSink = events

        val callback: (List<MessageModel>) -> Unit = { messages ->
            if (activeSink === events) {
                try {
                    events.success(messages.map { msg ->
                        mapOf(
                            "id"         to msg.messageId,
                            "chatId"     to msg.chatId,
                            "senderId"   to msg.senderId,
                            "receiverId" to msg.receiverId,
                            "content"    to msg.content,
                            "status"     to msg.status,
                            "timestamp"  to msg.timestamp,
                        )
                    })
                } catch (_: Throwable) { /* messenger shut down */ }
            }
        }

        syncManager.subscribe(chatId, callback)

        cancelHandler = {
            if (activeSink === events) activeSink = null
            syncManager.unsubscribe(chatId, callback)
        }
    }

    override fun onCancel(arguments: Any?) {
        cancelHandler?.invoke()
        cancelHandler = null
    }
}