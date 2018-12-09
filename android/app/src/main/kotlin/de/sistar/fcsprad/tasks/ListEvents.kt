package de.sistar.fcsprad.tasks

import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.amazonaws.mobileconnectors.appsync.fetcher.AppSyncResponseFetchers
import com.apollographql.apollo.GraphQLCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import de.sistar.fcsprad.GetEventsQuery
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class ListEvents (private val client: AWSAppSyncClient, private val call: MethodCall, private val result: MethodChannel.Result) {

    operator fun invoke() {
        val query = GetEventsQuery.builder().build()
        client.query(query)
                .responseFetcher(AppSyncResponseFetchers.NETWORK_ONLY)
                .enqueue(object : GraphQLCall.Callback<GetEventsQuery.Data>() {

                    override fun onResponse(response: Response<GetEventsQuery.Data>) {
                        parseResponse(response)
                    }

                    override fun onFailure(e: ApolloException) {
                        result.error("onFailure", e.message, null)
                    }

                })
    }

    private fun parseResponse(response: Response<GetEventsQuery.Data>) {
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
                        "plannedAvg" to it.plannedAvg()
                )
            }

            messages?.let {
                val json = Gson().toJson(messages)
                result.success(json)
            } ?: run {
                result.success(null)
            }
        } else {
            val error = response.errors().map { it.message() }.joinToString(", ")
            result.error("Errors", error, null)
        }
    }

}