// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      id: json['id'] as String,
      name: json['name'] as String,
      where: json['where'] as String,
      lat: (json['lat'] as num)?.toDouble(),
      lon: (json['lon'] as num)?.toDouble(),
      startingTime: json['startingTime'] as String,
      description: json['description'] as String,
      discipline: json['discipline'] as String,
      distance: (json['distance'] as num)?.toDouble(),
      intensity: (json['intensity'] as num)?.toDouble(),
      plannedAvg: (json['plannedAvg'] as num)?.toDouble(),
      komoot: json['komoot'] as String,
      participants: (json['participants'] as List)
          ?.map((e) => e == null
              ? null
              : Participation.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..comments = (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'where': instance.where,
      'lat': instance.lat,
      'lon': instance.lon,
      'startingTime': instance.startingTime,
      'description': instance.description,
      'discipline': instance.discipline,
      'distance': instance.distance,
      'intensity': instance.intensity,
      'plannedAvg': instance.plannedAvg,
      'komoot': instance.komoot,
      'participants': instance.participants == null
          ? null
          : _ParticipationToJsonS(instance.participants),
      'comments': instance.comments
    };

Participation _$ParticipationFromJson(Map<String, dynamic> json) {
  return Participation(userId: json['userId'] as String);
}

Map<String, dynamic> _$ParticipationToJson(Participation instance) =>
    <String, dynamic>{'userId': instance.userId};

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      content: json['content'] as String,
      createdAt: json['createdAt'] as String);
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'content': instance.content,
      'createdAt': instance.createdAt
    };
