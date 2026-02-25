package com.example.chat_application_task.firestore

import com.google.firebase.firestore.FirebaseFirestore


class FirestoreService {

    private val db: FirebaseFirestore = FirebaseFirestore.getInstance()

    fun saveData(
        collection: String,
        docId: String,
        data: Map<String, Any>,
        onSuccess: () -> Unit,
        onError: (Exception) -> Unit,
    ) {
        db.collection(collection)
            .document(docId)
            .set(data)
            .addOnSuccessListener { onSuccess() }
            .addOnFailureListener { e -> onError(e) }
    }

    fun getData(
        collection: String,
        docId: String,
        onSuccess: (Map<String, Any>) -> Unit,
        onError: (Exception) -> Unit,
    ) {
        db.collection(collection)
            .document(docId)
            .get()
            .addOnSuccessListener { snapshot ->
                onSuccess(snapshot.data ?: emptyMap())
            }
            .addOnFailureListener { e -> onError(e) }
    }
}
