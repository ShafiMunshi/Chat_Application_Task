package com.example.chat_application_task.service

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.example.chat_application_task.models.MessageModel

class SyncManager(
    private  val connectivityService: ConnectivityService,
    private val localService: LocalService,
    private val chatService: ChatService,
) {
    private val mainHandler = Handler(Looper.getMainLooper())
    init {
        connectivityService.register();
    }

    fun sendMessage(
        messageData: Map<String, Any>,
        onSuccess: () -> Unit,
        onError: (Exception) -> Unit,
    ) {
        // Write locally as "pending" first — UI sees it immediately
        val pending = MessageModel.fromMap(messageData.toMutableMap().apply {
            put("status", "pending")
        })
        localService.insertMessage(pending);

        if (connectivityService.isOnline) {
            uploadToFirestore(pending, onSuccess, onError)
        }

    }

    private fun uploadToFirestore(
        message: MessageModel,
        onSuccess: () -> Unit,
        onError: (Exception) -> Unit,
    ) {
        val firestoreData = mapOf(
            "id"         to message.messageId,
            "chatId"     to message.chatId,
            "senderId"   to message.senderId,
            "receiverId" to message.receiverId,
            "content"    to message.content,
            "status"     to "sent",
            "timestamp"  to message.timestamp,
        )
        chatService.sendMessage(
            chatId      = message.chatId,
            messageData = firestoreData,
            onSuccess   = {
                localService.updateMessageStatus(message.messageId, "sent")
                mainHandler.post { onSuccess() }
            },
            onError     = { e ->
                Log.e("SyncManager", "Upload failed ${message.messageId}: ${e.message}")
                mainHandler.post { onError(e) }
            },
        )
    }
}