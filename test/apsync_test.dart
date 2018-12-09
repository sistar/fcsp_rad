import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcsp_rad/event_service.dart';
import 'package:fcsp_rad/default.dart';

void main(){
  group('event service', () {
    const MethodChannel channel = MethodChannel(
      'de.sistar.fcsp_rad',
    );
    var es = EventService();
    test('removing', () async {
      const String key = 'testKey';
     await es.sendEvent(defaultEvent, "b");



    });

  });
}

