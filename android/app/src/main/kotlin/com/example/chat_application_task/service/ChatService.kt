package com.example.chat_application_task.service

import android.os.Handler
import android.os.Looper
import com.google.firebase.firestore.FirebaseFirestore


class ChatService {

    private val db: FirebaseFirestore = FirebaseFirestore.getInstance()

    fun sendMessage(
        chatId: String,
        messageData: Map<String, Any>,
        onSuccess: () -> Unit,
        onError: (Exception) -> Unit,
    ) {
        val chatCollection = "CHATS"
        val messageCollection = "MESSAGES"

        db.collection(chatCollection)
            .document(chatId)
            .collection(messageCollection)
            .add(messageData)
            .addOnSuccessListener {
                val chatUpdateData = mapOf(
                    "lastMessage" to (messageData["content"] ?: ""),
                    "timestamp" to (messageData["timestamp"] ?: System.currentTimeMillis())
                )
                db.collection(chatCollection)
                    .document(chatId)
                    .update(chatUpdateData)
                    .addOnSuccessListener { mainThread { onSuccess() } }
                    .addOnFailureListener { e -> mainThread { onError(e) } }
            }
            .addOnFailureListener { e -> mainThread { onError(e) } }
    }

    private fun mainThread(block: () -> Unit) {
        Handler(Looper.getMainLooper()).post(block)
    }
}
