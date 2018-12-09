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
      komoot: json['komoot'] as String);
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
      'komoot': instance.komoot
    };
