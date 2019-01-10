package de.sistar.fcsprad.tasks

import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.apollographql.apollo.GraphQLCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import com.amazonaws.amplify.generated.graphql.AddParticipantMutation
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AddParticipant(private val client: AWSAppSyncClient, private val call: MethodCall, private val result: MethodChannel.Result) {

    operator fun invoke() {
        val participation = call.argument<HashMap<String,Any>>("participation")
        val event = call.argument<HashMap<String,Any>>("event")

        val builder = AddParticipantMutation.builder()

        builder.userId(participation?.get("userId").toString())
        builder.startingTime(event?.get("startingTime").toString())
        builder.eventId(event?.get("id").toString())


        val mutation = builder.build()

        client.mutate(mutation).enqueue(object : GraphQLCall.Callback<AddParticipantMutation.Data>() {


            override fun onResponse(response: Response<AddParticipantMutation.Data>) {
                parseResponse(response)
            }

            override fun onFailure(e: ApolloException) {
                result.error("onFailure", e.message, null)
            }

        })
    }

    private fun parseParticipants(participants: List<AddParticipantMutation.Participant>?): List<Map<String, String>> {
        return participants!!.map {
            mapOf("userId" to it.userId()!!);
        }
    }

    private fun parseComments(comments: List<AddParticipantMutation.Comment>?): List<Map<String, String>> {
        return comments!!.map {
            mapOf("content" to it.content(),
                    "createdAt" to it.createdAt())
        }
    }

    private fun parseResponse(response: Response<AddParticipantMutation.Data>) {
        if (response.hasErrors().not()) {
            val newMessage = response.data()?.addParticipant()?.let {
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