import 'package:fcsp_rad/event.dart';
import 'package:fcsp_rad/pages/event_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Event> _events;
  final Function _addEvent;
  final Function _deleteEvent;
  final Function _joinEvent;
  final Function _leaveEvent;

  HomePage(this._events, this._addEvent, this._deleteEvent, this._joinEvent,this._leaveEvent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bla  la'),
        ),
        body: EventList(_events, _addEvent, _deleteEvent,_joinEvent,_leaveEvent));
  }
}
