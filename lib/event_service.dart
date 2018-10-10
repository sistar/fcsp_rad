import 'dart:async';
import 'dart:convert';

import 'package:fcsp_rad/constants.dart';
import 'package:fcsp_rad/event.dart';
import 'package:flutter/services.dart';

class EventService {

  static const CHANNEL_NAME = 'de.sistar.fcsp_rad';
  static const QUERY_GET_ALL_EVENTS = 'listEvents';
  static const MUTATION_NEW_EVENT = 'createEvent';
  static const SUBSCRIBE_NEW_EVENT = 'subscribeNewEvent';
  static const SUBSCRIBE_NEW_EVENT_RESULT = 'subscribeNewEventResult';

  static const Map<String, dynamic> _DEFAULT_PARAMS = <String, dynamic> {
    'endpoint': AWS_APP_SYNC_ENDPOINT,
    'apiKey': AWS_APP_SYNC_KEY
  };

  static const MethodChannel APP_SYNC_CHANNEL = const MethodChannel(CHANNEL_NAME);

  EventService() {
    APP_SYNC_CHANNEL.setMethodCallHandler(_handleMethod);
  }

  final StreamController<Event> eventBroadcast = new StreamController<Event>.broadcast();

  Future<List<Event>> getAllEvents() async {
    String jsonString = await APP_SYNC_CHANNEL.invokeMethod(QUERY_GET_ALL_EVENTS, _buildParams());
    List<dynamic> values = json.decode(jsonString);
    return values.map((value) => Event.fromJson(value)).toList();
  }

  Future<Event> sendEvent(String content, String sender) async {
    final params = {
      "content": content,
      "sender": sender
    };
    String jsonString = await APP_SYNC_CHANNEL.invokeMethod(MUTATION_NEW_EVENT, _buildParams(otherParams: params));
    Map<String, dynamic> values = json.decode(jsonString);
    return Event.fromJson(values);
  }

  void subscribeNewEvent() {
    APP_SYNC_CHANNEL.invokeMethod(SUBSCRIBE_NEW_EVENT, _buildParams());
  }

  Future<Null> _handleMethod(MethodCall call) async {
    if (call.method == SUBSCRIBE_NEW_EVENT_RESULT) {
      String jsonString = call.arguments;
      try {
        Map<String, dynamic> values = json.decode(jsonString);
        Event event = Event.fromJson(values);
        eventBroadcast.add(event);
      } catch(e) {
        print(e);
      }
    }
    return null;
  }

  Map<String, dynamic> _buildParams({Map<String, dynamic> otherParams}) {
    final params = new Map<String, dynamic>.from(_DEFAULT_PARAMS);
    if (otherParams != null) {
      params.addAll(otherParams);
    }
    return params;
  }

}