package com.example.chat_application_task.service

import android.os.Handler
import android.os.Looper
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.Query
import com.google.firebase.firestore.SetOptions

class ChatService {

    private val db: FirebaseFirestore = FirebaseFirestore.getInstance()

    private val chatCollection = "CHATS"
    private val messageCollection = "MESSAGES"

    fun sendMessage(
        chatId: String,
        messageData: Map<String, Any>,
        onSuccess: () -> Unit,
        onError: (Exception) -> Unit,
    ) {
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
                    .set(chatUpdateData, SetOptions.merge())
                    .addOnSuccessListener { mainThread { onSuccess() } }
                    .addOnFailureListener { e -> mainThread { onError(e) } }
            }
            .addOnFailureListener { e -> mainThread { onError(e) } }
    }

    private fun mainThread(block: () -> Unit) {
        Handler(Looper.getMainLooper()).post(block)
    }

    fun listenForMessages(
        chatId: String,
        onUpdate: (List<Map<String, Any>>) -> Unit,
        onError: (Exception) -> Unit,
    ): ListenerRegistration {
        return db
            .collection(chatCollection)
            .document(chatId)
            .collection(messageCollection)
            .orderBy("timestamp", Query.Direction.ASCENDING)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    mainThread { onError(error) }
                    return@addSnapshotListener
                }
                val messages = snapshot?.documents
                    ?.mapNotNull { doc -> doc.data?.let { HashMap(it) } }
                    ?: emptyList()
                mainThread { onUpdate(messages) }
            }
    }
}
