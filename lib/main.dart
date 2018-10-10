import 'dart:async';

import 'package:fcsp_rad/event.dart';
import 'package:fcsp_rad/event_service.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FC SP RAD',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'FC SP RAD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _sender;

  final textEditingController = new TextEditingController();
  final eventService = new EventService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  List<Event> _events = [];

  void _init() async {
    eventService.subscribeNewEvent();
    _events.addAll(await eventService.getAllEvents());
    if (mounted) {
      setState(() {
        // refresh
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: (_sender == null) ? _buildConfigurationSender() : _buildTchat()  );
  }

  Widget _buildConfigurationSender() {
    return new Padding(
      padding: const EdgeInsets.all(32.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter your sender name',
            ),
          ),
          new SizedBox(height: 16.0),
          new RaisedButton(
            child: new Text("Validate"),
            onPressed: () {
              setState(() {
                if (textEditingController.text.isEmpty) {
                  final snackBar = SnackBar(
                      content: Text('Error, your sender name is empty'));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  return;
                }
                _sender = textEditingController.text;
                textEditingController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  StreamSubscription<Event> _streamSubscription;

  final GlobalKey<AnimatedListState> _animateListKey =
  new GlobalKey<AnimatedListState>();

  Widget _buildTchat() {
    if (_streamSubscription == null) {
      _streamSubscription =
          eventService.eventBroadcast.stream.listen((event) {
            _events.insert(0, event);
            _animateListKey.currentState?.insertItem(0);
          }, cancelOnError: false, onError: (e) => debugPrint(e));
    }

    return new Column(
      children: <Widget>[
        new Expanded(
          child: _buildList(),
        ),
        new Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Saisir votre event',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _sendEvent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendEvent() {
    final content = textEditingController.text;
    if (content.trim().isEmpty) {
      final snackBar = SnackBar(content: Text('Error, your event is empty'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    eventService.sendEvent(content, _sender);
    textEditingController.clear();
  }

  Widget _buildList() {
    return new AnimatedList(
      key: _animateListKey,
      reverse: true,
      initialItemCount: _events.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        final event = _events[index];
        return new Directionality(
          textDirection:
          event.id == _sender ? TextDirection.rtl : TextDirection.ltr,
          child: new SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation,
            child: _buildEventItem(event),
          ),
        );
      },
    );
  }

  Widget _buildEventItem(Event event) {
    return new ListTile(
      title: new Text(event.name),
      subtitle: new Text(event.when),
    );
  }

}
