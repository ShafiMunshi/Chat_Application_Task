package com.example.chat_application_task.service

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.example.chat_application_task.models.MessageModel

class LocalService(context: Context) : SQLiteOpenHelper(
    context,
    DATABASE_NAME,
    null,
    DATABASE_VERSION,
) {

    companion object {
        private const val DATABASE_NAME    = "chat_local.db"
        private const val DATABASE_VERSION = 1

        private const val TABLE_MESSAGES   = "messages"

        private const val COL_MESSAGE_ID   = "message_id"
        private const val COL_CHAT_ID      = "chat_id"
        private const val COL_SENDER_ID    = "sender_id"
        private const val COL_RECEIVER_ID  = "receiver_id"
        private const val COL_CONTENT      = "content"
        private const val COL_STATUS       = "status"
        private const val COL_TIMESTAMP    = "timestamp"
    }

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(
            """
            CREATE TABLE $TABLE_MESSAGES (
                $COL_MESSAGE_ID  TEXT PRIMARY KEY,
                $COL_CHAT_ID     TEXT NOT NULL,
                $COL_SENDER_ID   TEXT NOT NULL,
                $COL_RECEIVER_ID TEXT NOT NULL,
                $COL_CONTENT     TEXT NOT NULL,
                $COL_STATUS      TEXT NOT NULL,
                $COL_TIMESTAMP   TEXT NOT NULL
            )
            """.trimIndent()
        )
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_MESSAGES")
        onCreate(db)
    }

    fun insertMessage(message: MessageModel) {
        writableDatabase.use { db ->
            db.insertWithOnConflict(
                TABLE_MESSAGES,
                null,
                message.toContentValues(),
                SQLiteDatabase.CONFLICT_REPLACE,
            )
        }
    }

    fun getChatMessages(chatId: String): List<MessageModel> {
        val messages = mutableListOf<MessageModel>()
        readableDatabase.use { db ->
            db.query(
                TABLE_MESSAGES,
                null,
                "$COL_CHAT_ID = ?",
                arrayOf(chatId),
                null, null,
                "$COL_TIMESTAMP ASC",
            ).use { cursor ->
                while (cursor.moveToNext()) {
                    messages.add(cursor.toMessageModel())
                }
            }
        }
        return messages
    }

    fun getIndivMessage(messageId: String): MessageModel? {
        return readableDatabase.use { db ->
            db.query(
                TABLE_MESSAGES,
                null,
                "$COL_MESSAGE_ID = ?",
                arrayOf(messageId),
                null, null, null,
            ).use { cursor ->
                if (cursor.moveToFirst()) cursor.toMessageModel() else null
            }
        }
    }

    fun updateMessageStatus(messageId: String, status: String): Int {
        return writableDatabase.use { db ->
            val values = ContentValues().apply { put(COL_STATUS, status) }
            db.update(
                TABLE_MESSAGES,
                values,
                "$COL_MESSAGE_ID = ?",
                arrayOf(messageId),
            )
        }
    }

    fun deleteIndivMessage(messageId: String): Int {
        return writableDatabase.use { db ->
            db.delete(TABLE_MESSAGES, "$COL_MESSAGE_ID = ?", arrayOf(messageId))
        }
    }

    fun deleteAllMessagesOfChat(chatId: String): Int {
        return writableDatabase.use { db ->
            db.delete(TABLE_MESSAGES, "$COL_CHAT_ID = ?", arrayOf(chatId))
        }
    }

    private fun MessageModel.toContentValues() = ContentValues().apply {
        put(COL_MESSAGE_ID,  messageId)
        put(COL_CHAT_ID,     chatId)
        put(COL_SENDER_ID,   senderId)
        put(COL_RECEIVER_ID, receiverId)
        put(COL_CONTENT,     content)
        put(COL_STATUS,      status)
        put(COL_TIMESTAMP,   timestamp)
    }

    private fun android.database.Cursor.toMessageModel() = MessageModel(
        messageId  = getString(getColumnIndexOrThrow(COL_MESSAGE_ID)),
        chatId     = getString(getColumnIndexOrThrow(COL_CHAT_ID)),
        senderId   = getString(getColumnIndexOrThrow(COL_SENDER_ID)),
        receiverId = getString(getColumnIndexOrThrow(COL_RECEIVER_ID)),
        content    = getString(getColumnIndexOrThrow(COL_CONTENT)),
        status     = getString(getColumnIndexOrThrow(COL_STATUS)),
        timestamp  = getString(getColumnIndexOrThrow(COL_TIMESTAMP)),
    )
}
