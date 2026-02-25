package com.example.chat_application_task.models

data class MessageModel(
    val messageId: String,
    val chatId: String,
    val senderId: String,
    val receiverId: String,
    val content: String,
    val status: String,
    val timestamp: String,
){
    companion object {
        fun fromMap(data: Map<String, Any>): MessageModel {
            return MessageModel(
                messageId = (data["id"] ?: data["messageId"]) as String,
                chatId = data["chatId"] as String,
                senderId = data["senderId"] as String,
                receiverId = data["receiverId"] as String,
                content = data["content"] as String,
                status = (data["status"] as? String) ?: "sent",
                timestamp = (data["timestamp"] as String),
            )
        }

        fun isAnyDataMissing(data: Map<String, Any>): Boolean {
            val requiredKeys = listOf("chatId", "senderId", "receiverId", "content", "timestamp")
            return requiredKeys.any { key -> !data.containsKey(key) }
        }
    }
}