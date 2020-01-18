import 'package:fcsp_rad/event.dart';
import 'package:fcsp_rad/pages/event.dart';
import 'package:flutter/material.dart';

class Events extends StatelessWidget {
  List<Event> _events;
  final Function _joinEvent;
  final Function _leaveEvent;

  Events(this._events, this._joinEvent, this._leaveEvent);

  Widget _buildEventItem(BuildContext context, int index) {
    Event element = _events[index];
    return Card(
        child: Column(children: <Widget>[
      //Image.asset('assets/food.jpg'),
      Text(element.name),
      Text(element.description ?? ""),
      Text(element.startingTime ?? ""),
      Text(element.distance?.toString() ?? ""),
      Text(element.intensity?.toString() ?? ""),
      Text(element.plannedAvg?.toString() ?? ""),
      Text(element.lat?.toString() ?? ""),
      Text(element.lon?.toString() ?? ""),
      Text(element.discipline ?? ""),
      Text(element.komoot ?? "https://komoot.com/"),
      Column(
          children: element.participants.map((p) {
        return Text(p.userId);
      }).toList()),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.pushNamed(context, '/event/$index');
              }),
          FlatButton(
            child: Text('Join'),
            onPressed: () {
              _joinEvent(element);
            },
          ),
          IconButton(
              icon: Icon(
                Icons.library_add,
                color: Theme.of(context).accentColor,
              ),
              onPressed: (){
                _joinEvent(element);
              })
        ],
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    print('[Events Widget] build()');
    Widget displayed;
    if (_events.length > 0) {
      displayed = ListView.builder(
        itemBuilder: _buildEventItem,
        itemCount: _events.length,
      );
    } else {
      displayed = Center(
        child: Text('No events found. Please add some!'),
      );
    }
    return displayed;
  }
}
