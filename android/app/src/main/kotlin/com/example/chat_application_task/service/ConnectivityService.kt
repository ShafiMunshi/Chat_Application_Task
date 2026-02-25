package com.example.chat_application_task.service

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest

class ConnectivityService(context: Context) {

    private val connectivityManager =
        context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    var onConnected: (() -> Unit)? = null
    var onDisconnected: (() -> Unit)? = null

    val isOnline: Boolean
        get() {
            val net = connectivityManager.activeNetwork ?: return false
            val caps = connectivityManager.getNetworkCapabilities(net) ?: return false
            return caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
        }

    fun register() {
        val request = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)  // was INTERNET
            .build()

        connectivityManager.registerNetworkCallback(request,
            object : ConnectivityManager.NetworkCallback() {
                private var wasOnline = isOnline

                override fun onAvailable(network: Network) {
                    if (!wasOnline) {
                        wasOnline = true
                        onConnected?.invoke()
                    }
                }

                override fun onLost(network: Network) {
                    if (!isOnline) {
                        wasOnline = false
                        onDisconnected?.invoke()
                    }
                }
            },
        )
    }
}