import 'package:fcsp_rad/default.dart';
import 'package:fcsp_rad/event.dart';
import 'package:flutter/material.dart';

import './events.dart';
import './event.dart';
import './default.dart';
import './events_control.dart';

class EventManager extends StatelessWidget {

  final List<Event> _events;
  final Function _addEvent;
  final Function _deleteEvent;

  EventManager(this._events,this._addEvent,this._deleteEvent);

  @override
  Widget build(BuildContext context) {
    print('[EventManager State] build()');
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: EventControl(_addEvent),
        ),
        Expanded(child: Events(_events))
      ],
    );
  }
}
