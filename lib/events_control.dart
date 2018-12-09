library fcsp_rad.events_control;

import 'package:fcsp_rad/default.dart';
import 'package:fcsp_rad/pages/event_add.dart';
import 'package:flutter/material.dart';

class EventControl extends StatelessWidget {
  final Function addEvent;

  EventControl(this.addEvent);

  _navigateAndAddCreatedEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => EventEditor(addEvent)),
    );
    // now will be null addEvent(result);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      onPressed: () {
        _navigateAndAddCreatedEvent(context);
      },
      child: Text('Add Event'),
    );
  }
}
