import 'package:fcsp_rad/event.dart';
import 'package:fcsp_rad/event_manager.dart';
import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  final List<Event> _events;
  final Function _addEvent;
  final Function _deleteEvent;

  EventList(this._events,this._addEvent,this._deleteEvent);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text('List of events')),

      body: new EventManager(_events,_addEvent,_deleteEvent),
    );
  }
}