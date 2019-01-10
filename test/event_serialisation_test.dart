import 'package:fcsp_rad/event.dart';
import "package:test/test.dart";

void main() {
  test("String.split() splits the string on the delimiter", () {
    var string = "foo,bar,baz";
    expect(string.split(","), equals(["foo", "bar", "baz"]));
  });

  test("String.trim() removes surrounding whitespace", () {
    var string = "  foo ";
    expect(string.trim(), equals("foo"));
  });

  var ev = new Event(id: "1234",participants: [Participation(userId: "foo"),Participation(userId: "bar")]);

  test("serialize event to json", (){

    var json = Event.toJson(ev);
    print(json);
    expect(json['participants'],equals([{"userId": "foo"},{"userId": "bar"}]));
  });

  test("deserialize from json",(){
  var json = Event.toJson(ev);

  expect(Event.fromJson(json).id, equals(ev.id));
  expect(Event.fromJson(json).participants[0].userId, equals(ev.participants[0].userId));
  });
}