package com.example.chat_application_task.channel

import com.example.chat_application_task.firestore.FirestoreService
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ChatMethodChannelHandler(
    private val firestoreService: FirestoreService,
) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.example.chat/channel"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveData" -> handleSaveData(call, result)
            "getData"  -> handleGetData(call, result)
            else       -> result.notImplemented()
        }
    }

    private fun handleSaveData(call: MethodCall, result: MethodChannel.Result) {
        val collection = call.argument<String>("collection")
        val docId      = call.argument<String>("docId")
        val data       = call.argument<Map<String, Any>>("data")

        if (collection == null || docId == null || data == null) {
            result.error("INVALID_ARG", "collection, docId and data are required", null)
            return
        }

        firestoreService.saveData(
            collection = collection,
            docId      = docId,
            data       = data,
            onSuccess  = { result.success(null) },
            onError    = { e -> result.error("FIRESTORE_ERROR", e.message, null) },
        )

    }
    
    private fun handleGetData(call: MethodCall, result: MethodChannel.Result) {
        val collection = call.argument<String>("collection")
        val docId      = call.argument<String>("docId")

        if (collection == null || docId == null) {
            result.error("INVALID_ARG", "collection and docId are required", null)
            return
        }

        firestoreService.getData(
            collection = collection,
            docId      = docId,
            onSuccess  = { data -> result.success(data) },
            onError    = { e -> result.error("FIRESTORE_ERROR", e.message, null) },
        )
    }
}
