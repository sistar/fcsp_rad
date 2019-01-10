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

  @JsonKey(toJson: _ParticipationToJsonS,fromJson: _$ParticipationFromJson)
  List<Participation> participants;

  List<Comment> comments;
  Event({this.id, this.name, this.where,this.lat,this.lon,this.startingTime,this.description,
  this.discipline,this.distance,this.intensity,this.plannedAvg,this.komoot,List<Participation> participants}) : participants = participants ?? <Participation>[];


  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  static toJson(Event event) => _$EventToJson(event);

}

@JsonSerializable()
class Participation{

  final String userId;

  Participation({this.userId});

  factory Participation.fromJson(Map<String,dynamic> json) => _$ParticipationFromJson(json);
  static toJson(Participation participation) =>_$ParticipationToJson(participation);
}

@JsonSerializable()
class Comment{
  final String content;
  final String createdAt;
  Comment({this.content,this.createdAt});

  factory Comment.fromJson(Map<String,dynamic> json) => _$CommentFromJson(json);
  static toJson(Comment comment) => _$CommentToJson(comment);

}

List<Map<String, dynamic>> _ParticipationToJsonS(List<Participation> l) =>
    l.map((instance) => <String, dynamic>{'userId': instance.userId}).toList();
