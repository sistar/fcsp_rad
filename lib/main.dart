import 'dart:async';

import 'package:fcsp_rad/event.dart';
import 'package:fcsp_rad/event_service.dart';
import 'package:fcsp_rad/pages/event.dart';
import 'package:fcsp_rad/pages/event_add.dart';
import 'package:fcsp_rad/pages/home.dart';
import 'package:fcsp_rad/secret.dart';
import 'package:fcsp_rad/secret_loader.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart' as random;

import './pages/event_list.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  const API_KEY = "AIzaSyAyN1BthqX_T0VsGT6a4qZj56buc5gSQww";
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyApp({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _storage = new FlutterSecureStorage();
  var _secret;

  final eventService = new EventService();
  String _sender = 'the_sender_in_this_case' + random.randomAlpha(5);
  final List<Event> _events = [];
  StreamSubscription<Event> _streamSubscription;

  @override
  void initState() {
    super.initState();
    Future<Secret> secret = SecretLoader(secretPath: "secrets.json").load();
    secret.then((result) {
      setState(() {
        _secret = result;
      });
    });
    _init();
  }

  void _init() async {
    eventService.subscribeNewEvent();
    _events.addAll(await eventService.getAllEvents());
    if (mounted) {
      setState(() {
        // refresh
      });
    }
  }

  void _addEvent(Event event) {
    setState(() {
      _events.add(event);
      eventService.sendEvent(event, _sender);
    });
    print(_events);
  }

  void _deleteEvent(Event event) {
    setState(() {
      _events.remove(event);
    });
    print(_events);
  }

  void _joinEvent(Event event) {
    setState(() {
      var modifiedEvent = eventService.addParticipant(
          new Participation(userId: 'fooUser'), event, _sender);
      modifiedEvent.then((er) {
        _events.removeWhere((e) {
         return e.id == er.id;
        });
        _events.add(er);
      });
    });
  }

  void _leaveEvent(Event event) {
    setState(() {
      eventService.removeParticipant(
          new Participation(userId: 'fooUser'), event, _sender);
    });
  }

  final GlobalKey<AnimatedListState> _animateListKey =
      new GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    if (_streamSubscription == null) {
      _streamSubscription = eventService.eventBroadcast.stream.listen((event) {
        _events.insert(0, event);
        _animateListKey.currentState?.insertItem(0);
      }, cancelOnError: false, onError: (e) => debugPrint(e));
    }

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
      routes: {
        '/': (BuildContext context) =>
            EventList(_events, _addEvent, _addEvent, _joinEvent, _leaveEvent),
        '/editor': (BuildContext context) => EventEditor(_addEvent),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'event') {
          final int index = int.parse(pathElements[2]);
          return new MaterialPageRoute(
              builder: (BuildContext context) => EventPage(_events[index]));
        }
      },
    );
  }
}
