package com.example.chat_application_task.channel

import android.util.Log
import com.example.chat_application_task.models.MessageModel
import com.example.chat_application_task.service.SyncManager
import io.flutter.plugin.common.EventChannel

class LocalEventChannelHandler(
    private val syncManager: SyncManager,
) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.chat/local_messages"
        private const val TAG = "LocalEventChannel"
    }

    private var activeSink: EventChannel.EventSink? = null
    private var cancelHandler: (() -> Unit)? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val chatId = (arguments as? Map<*, *>)?.get("chatId") as? String
        if (chatId == null) {
            events.error("INVALID_ARG", "chatId is required", null)
            return
        }

        // Clean up any previous subscription (handles hot restart)
        try {
            cancelHandler?.invoke()
        } catch (e: Throwable) {
            Log.w(TAG, "Error cleaning up previous stream: ${e.message}")
        }
        cancelHandler = null
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
                } catch (e: Throwable) {
                    Log.w(TAG, "Sink already closed, ignoring: ${e.message}")
                }
            }
        }

        try {
            syncManager.subscribe(chatId, callback)
        } catch (e: Exception) {
            Log.e(TAG, "subscribe failed: ${e.message}", e)
            // Clean up the state we just set so onCancel doesn't double-fire
            cancelHandler = null
            activeSink = null
            events.error("error", e.message, null)
            return
        }

        cancelHandler = {
            if (activeSink === events) activeSink = null
            syncManager.unsubscribe(chatId, callback)
        }
    }

    override fun onCancel(arguments: Any?) {
        try {
            cancelHandler?.invoke()
        } catch (e: Throwable) {
            Log.w(TAG, "Error during onCancel: ${e.message}")
        }
        cancelHandler = null
        activeSink = null
    }
}