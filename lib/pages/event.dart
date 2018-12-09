import 'package:fcsp_rad/event.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget{
  Event event;

  EventPage(Event this.event){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Center(child: Text(event.description ?? "this event has no description"),),
    );


  }
}