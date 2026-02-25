package com.example.chat_application_task.service

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.example.chat_application_task.models.MessageModel
import com.google.firebase.firestore.ListenerRegistration

class SyncManager(
    private  val connectivityService: ConnectivityService,
    private val localService: LocalService,
    private val chatService: ChatService,
) {
    private val mainHandler = Handler(Looper.getMainLooper())

    // chatId → subscriber callbacks
    private val subscribers = HashMap<String, MutableList<(List<MessageModel>) -> Unit>>()

    // Active Firestore real-time listeners per chatId
    private val firestoreListeners = HashMap<String, ListenerRegistration>()

    init {
        connectivityService.onConnected = {
            Log.d("SyncManager", "Internet connected - flushing pending messages")
            flushPendingMessages()
        }
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
        notifySubscribers(pending.chatId)

        if (connectivityService.isOnline) {
            uploadToFirestore(pending, onSuccess, onError)
        } else {
            Log.d("SyncManager", "Offline — queued: ${pending.messageId}")
            mainHandler.post { onSuccess() }
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
                notifySubscribers(message.chatId)
                mainHandler.post { onSuccess() }
            },
            onError     = { e ->
                Log.e("SyncManager", "Upload failed ${message.messageId}: ${e.message}")
                mainHandler.post { onError(e) }
            },
        )
    }

    private fun flushPendingMessages() {
        localService.getAllPendingMessages().forEach { msg ->
            uploadToFirestore(msg, {}, {})
        }
    }

    fun subscribe(chatId: String, callback: (List<MessageModel>) -> Unit) {
        subscribers.getOrPut(chatId) { mutableListOf() }.add(callback)
        // Emit local snapshot immediately so UI is not blank
        mainHandler.post { callback(localService.getChatMessages(chatId)) }
        if (!firestoreListeners.containsKey(chatId)) {
            startFirestoreListener(chatId)
        }
    }

    private fun notifySubscribers(chatId: String) {
        val snapshot = localService.getChatMessages(chatId)
        mainHandler.post { subscribers[chatId]?.forEach { it(snapshot) } }
    }

    fun unsubscribe(chatId: String, callback: (List<MessageModel>) -> Unit) {
        subscribers[chatId]?.remove(callback)
        if (subscribers[chatId]?.isEmpty() == true) {
            firestoreListeners[chatId]?.remove()
            firestoreListeners.remove(chatId)
            subscribers.remove(chatId)
        }
    }

    private fun startFirestoreListener(chatId: String) {
        val reg = chatService.listenForMessages(
            chatId   = chatId,
            onUpdate = { remoteMaps ->
                remoteMaps.forEach { map ->
                    try {
                        val remote = MessageModel.fromMap(
                            map.toMutableMap().apply { put("status", "sent") }
                        )
                        val existing = localService.getIndivMessage(remote.messageId)
                        // Never overwrite a locally pending message
                        if (existing == null || existing.status != "pending") {
                            localService.insertMessage(remote)
                        }
                    } catch (e: Exception) {
                        Log.e("SyncManager", "Parse error: ${e.message}")
                    }
                }
                notifySubscribers(chatId)
            },
            onError  = { e ->
                Log.e("SyncManager", "Firestore error $chatId: ${e.message}")
            },
        )
        firestoreListeners[chatId] = reg
    }
}