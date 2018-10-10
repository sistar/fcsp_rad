import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends Object {

  final String id;

  final String name;
  final String where;
  final double lat;
  final double lon;
  final String when;
  final String description;
  final String discipline;
  final String distance;
  final double intensity;
  final double plannedAvg;
  final String komoot;

  Event({this.id, this.name, this.where,this.lat,this.lon,this.when,this.description,
  this.discipline,this.distance,this.intensity,this.plannedAvg,this.komoot});


  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

}
