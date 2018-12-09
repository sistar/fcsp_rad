import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends Object {

  final String id;

  final String name;
  final String where;
  final double lat;
  final double lon;
  final String startingTime;
  final String description;
  final String discipline;
  final double distance;
  final double intensity;
  final double plannedAvg;
  final String komoot;

  Event({this.id, this.name, this.where,this.lat,this.lon,this.startingTime,this.description,
  this.discipline,this.distance,this.intensity,this.plannedAvg,this.komoot});


  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  static toJson(Event event) => _$EventToJson(event);

}
