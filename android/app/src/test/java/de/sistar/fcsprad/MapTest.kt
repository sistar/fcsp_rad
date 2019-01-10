package de.sistar.fcsprad

import com.amazonaws.amplify.generated.graphql.GetEventsQuery
import junit.framework.AssertionFailedError
import org.junit.Assert
import org.junit.Test

class MapTest {
    @Test
    fun mappingToAList(): Unit {
         fun parseParticipants(participants: List<GetEventsQuery.Participant>? ): List<Map<String,String>>{
            return participants!!.map {  mapOf("userId" to it.userId()!!);

            }
        }
        val r = parseParticipants(listOf(GetEventsQuery.Participant("a", "the event","infokey","userx")))
        Assert.assertNotNull(r)
    }
}