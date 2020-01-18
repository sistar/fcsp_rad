package de.sistar.fcsprad.tasks

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.amazonaws.amplify.generated.graphql.GetEventsQuery
import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.amazonaws.mobileconnectors.appsync.fetcher.AppSyncResponseFetchers
import com.apollographql.apollo.GraphQLCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ListEvents(private val client: AWSAppSyncClient, private val call: MethodCall, private val result: MethodChannel.Result) {

    operator fun invoke() {
        val query = GetEventsQuery.builder().build()
        client.query(query)
                .responseFetcher(AppSyncResponseFetchers.NETWORK_ONLY)
                .enqueue(object : GraphQLCall.Callback<GetEventsQuery.Data>() {

                    override fun onResponse(response: Response<GetEventsQuery.Data>) {
                        Log.e("ListEvents.onResponse", "........ on response")

                        parseResponse(response)
                    }

                    override fun onFailure(e: ApolloException) {
                        Log.e("ListEvents.onFailure", "....... on failure", e)

                        result.error("onFailure", e.message, null)
                    }
                })
    }


    private fun parseParticipants(participants: List<GetEventsQuery.Participant>?): List<Map<String, String>> {
        return participants!!.map {
            mapOf("userId" to it.userId()!!);
        }
    }

    private fun parseComments(comments: List<GetEventsQuery.Comment>?): List<Map<String, String>> {
        return comments!!.map {
            mapOf("content" to it.content(),
                    "createdAt" to it.createdAt())
        }
    }

    private fun parseResponse(response: Response<GetEventsQuery.Data>) {
        Log.e("ListEvents.parseResp", "....... parse response")
        println("ListEvents.parseResponse")
        if (response.hasErrors().not()) {
            val messages = response.data()?.events?.map {
                return@map mapOf(
                        "id" to it.id(),
                        "name" to it.name(),
                        "where" to it.where(),
                        "startingTime" to it.startingTime(),
                        "description" to it.description(),
                        "discipline" to it.discipline(),
                        "distance" to it.distance(),
                        "intensity" to it.intensity(),
                        "lat" to it.lat(),
                        "lon" to it.lon(),
                        "komoot" to it.komoot(),
                        "plannedAvg" to it.plannedAvg(),
                        "participants" to parseParticipants(it.participants()),
                        "comments" to parseComments(it.comments())
                )
            }

            messages?.let {
                val json = Gson().toJson(messages)

                Handler(Looper.getMainLooper()).post {
                    result.success(json)
                }
            } ?: run {
                Handler(Looper.getMainLooper()).post {
                    result.success(null)
                }
            }
        } else {
            val error = response.errors().map { it.message() }.joinToString(", ")
            Handler(Looper.getMainLooper()).post {
                result.error("Errors", error, null)
            }

        }
    }

}