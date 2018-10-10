package de.sistar.fcsprad
import com.amazonaws.mobileconnectors.appsync.AWSAppSyncClient
import com.amazonaws.mobileconnectors.appsync.sigv4.BasicAPIKeyAuthProvider
import com.amazonaws.regions.Regions
import de.sistar.fcsprad.tasks.ListEvents
import de.sistar.fcsprad.tasks.NewMessage
import de.sistar.fcsprad.tasks.SubscriptionToNewEvent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/**
 * Plugin to call GraphQL requests generated from the schema
 */
class AppSyncPlugin private constructor(private val registrar: PluginRegistry.Registrar, private val channel: MethodChannel) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "de.sistar.fcsp_rad"
        const val QUERY_GET_ALL_EVENTS = "listEvents"
        const val MUTATION_NEW_EVENT = "createEvent"
        const val SUBSCRIBE_NEW_EVENT = "subscribeNewEvent"
        const val SUBSCRIBE_NEW_EVENT_RESULT = "subscribeNewEventResult"

        fun registerWith(registrar: PluginRegistry.Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            val instance = AppSyncPlugin(registrar, channel)
            channel.setMethodCallHandler(instance)
        }
    }

    /**
     * Client AWS AppSync for call GraphQL requests
     */
    var client: AWSAppSyncClient? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        prepareClient(call)
        onPerformMethodCall(call, result)
    }

    /**
     * Handle type method. Call task for run GraphQL request
     */
    private fun onPerformMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            QUERY_GET_ALL_EVENTS -> ListEvents(client!!, call, result)()
            MUTATION_NEW_EVENT -> NewMessage(client!!, call, result)()
            SUBSCRIBE_NEW_EVENT -> (SubscriptionToNewEvent(client!!, call, channel))()
            else -> result.notImplemented()
        }
    }

    /**
     * Create AWS AppSync Client if not exist
     */
    private fun prepareClient(call: MethodCall) {
        val endpoint = call.argument<String>("endpoint")
        val apiKey = call.argument<String>("apiKey")

        if (client == null) {
            client = AWSAppSyncClient.builder()
                    .context(registrar.context().applicationContext)
                    .apiKey(BasicAPIKeyAuthProvider(apiKey))
                    .region(Regions.EU_CENTRAL_1)
                    .serverUrl(endpoint)
                    .build()
        }
    }

}