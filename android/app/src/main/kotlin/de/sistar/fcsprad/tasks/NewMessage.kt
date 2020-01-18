package de.sistar.fcsprad.tasks

import android.os.Handler
import android.os.Looper
import com.amazonaws.amplify.generated.graphql.CreateEventMutation
import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.apollographql.apollo.GraphQLCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class NewMessage(private val client: AWSAppSyncClient, private val call: MethodCall, private val result: MethodChannel.Result) {

    operator fun invoke() {
        val content = call.argument<HashMap<String, Any>>("content")

        val builder = CreateEventMutation.builder()

        builder.name(content?.get("name").toString())
        builder.where(content?.get("where").toString())
        builder.startingTime(content?.get("startingTime").toString())
        builder.description(content?.get("description").toString())
        builder.discipline(content?.get("discipine").toString())
        builder.distance((content?.get("distance") as Double))
        builder.intensity((content.get("intensity") as Double))
        builder.lat((content.get("lat") as Double))
        builder.lon((content.get("lon") as Double))
        builder.plannedAvg((content.get("plannedAvg") as Double))
        builder.komoot(content.get("komoot").toString())

        val mutation = builder.build()

        client.mutate(mutation).enqueue(object : GraphQLCall.Callback<CreateEventMutation.Data>() {


            override fun onResponse(response: Response<CreateEventMutation.Data>) {
                parseResponse(response)
            }

            override fun onFailure(e: ApolloException) {
                Handler(Looper.getMainLooper()).post {
                    result.error("onFailure", e.message, null)
                }
            }

        })
    }

    private fun parseResponse(response: Response<CreateEventMutation.Data>) {
        if (response.hasErrors().not()) {
            val newMessage = response.data()?.createEvent()?.let {
                return@let mapOf(
                        "id" to it.id(),
                        "name" to it.name(),
                        "where" to it.where(),
                        "startingTime" to it.startingTime(),
                        "description" to it.description(),
                        "distance" to it.distance(),
                        "intensity" to it.intensity(),
                        "lat" to it.lat(),
                        "lon" to it.lon(),
                        "komoot" to it.komoot(),
                        "plannedAvg" to it.plannedAvg()
                )
            }

            newMessage?.let {
                val json = Gson().toJson(newMessage)
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