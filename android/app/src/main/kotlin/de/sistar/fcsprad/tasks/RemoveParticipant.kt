package de.sistar.fcsprad.tasks

import com.amazonaws.amplify.generated.graphql.RemoveParticipantMutation
import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.apollographql.apollo.GraphQLCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class RemoveParticipant(private val client: AWSAppSyncClient, private val call: MethodCall, private val result: MethodChannel.Result) {

    operator fun invoke() {
        val participation = call.argument<HashMap<String,Any>>("participation")
        val event = call.argument<HashMap<String,Any>>("event")


        val builder = RemoveParticipantMutation.builder()

        builder.userId(participation?.get("userId").toString())
        builder.eventId(event?.get("id").toString())

        val mutation = builder.build()

        client.mutate(mutation).enqueue(object : GraphQLCall.Callback<RemoveParticipantMutation.Data>() {


            override fun onResponse(response: Response<RemoveParticipantMutation.Data>) {
                parseResponse(response)
            }

            override fun onFailure(e: ApolloException) {
                result.error("onFailure", e.message, null)
            }

        })
    }

    private fun parseParticipants(participants: List<RemoveParticipantMutation.Participant>?): List<Map<String, String>> {
        return participants!!.map {
            mapOf("userId" to it.userId()!!);
        }
    }

    private fun parseComments(comments: List<RemoveParticipantMutation.Comment>?): List<Map<String, String>> {
        return comments!!.map {
            mapOf("content" to it.content(),
                    "createdAt" to it.createdAt())
        }
    }
    private fun parseResponse(response: Response<RemoveParticipantMutation.Data>) {
        if (response.hasErrors().not()) {
            val newMessage = response.data()?.removeParticipant()?.let {
                return@let mapOf(
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

            newMessage?.let {
                val json = Gson().toJson(newMessage)
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