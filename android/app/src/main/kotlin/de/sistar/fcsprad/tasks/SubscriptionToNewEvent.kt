package de.sistar.fcsprad.tasks

import com.amazonaws.amplify.generated.graphql.SubscribeNewEventSubscription
import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.amazonaws.mobileconnectors.appsync.AppSyncSubscriptionCall
import com.apollographql.apollo.api.Response
import com.apollographql.apollo.exception.ApolloException
import com.google.gson.Gson
import de.sistar.fcsprad.AppSyncPlugin



import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Task for execute the subscription SubscribeToNewEvent in GraphQL file
 * <pre>
 * subscription SubscribeToNewEvent {
 *  subscribeToNewEvent {
 *      id
 *      content
 *      sender
 *  }
 * }
 * </pre>
 */
class SubscriptionToNewEvent(private val client: AWSAppSyncClient, private val call: MethodCall, private val channel: MethodChannel) {

    operator fun invoke() {
        val subscription = SubscribeNewEventSubscription.builder().build()
        val subscriber = client.subscribe(subscription)
        subscriber.execute(object : AppSyncSubscriptionCall.Callback<SubscribeNewEventSubscription.Data> {

            override fun onFailure(e: ApolloException) {
                channel.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_EVENT_RESULT, null)
            }

            override fun onResponse(response: Response<SubscribeNewEventSubscription.Data>) {
                val newMessage = response.data()?.subscribeNewEvent()?.let {
                    return@let mapOf(
                            "id" to it.id(),
                            "name" to it.name(),
                            "where" to it.where(),
                            "startingTime" to it.startingTime(),
                            "description" to it.description(),
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
                    channel.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_EVENT_RESULT, json)
                } ?: run {
                    channel.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_EVENT_RESULT, null)
                }
            }

            override fun onCompleted() {
                channel.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_EVENT_RESULT, null)
            }

        })
    }

}