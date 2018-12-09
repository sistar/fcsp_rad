import 'package:fcsp_rad/event.dart';
import 'package:fcsp_rad/pages/event_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Event> _events;
  final Function _addEvent;
  final Function _deleteEvent;

  HomePage(this._events, this._addEvent, this._deleteEvent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bla  la'),
        ),
        body: EventList(_events, _addEvent, _deleteEvent));
  }
}
