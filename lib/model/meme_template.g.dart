// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemeTemplate _$MemeTemplateFromJson(Map<String, dynamic> json) => MemeTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      originalImageUrl: json['originalImageUrl'] as String,
      detailUrl: json['detailUrl'] as String,
      source: json['source'] as String?,
      crawledAt: DateTime.parse(json['crawledAt'] as String),
      imageWidth: (json['imageWidth'] as num?)?.toInt(),
      imageHeight: (json['imageHeight'] as num?)?.toInt(),
      needRotate: json['needRotate'] as bool?,
    );

Map<String, dynamic> _$MemeTemplateToJson(MemeTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'originalImageUrl': instance.originalImageUrl,
      'detailUrl': instance.detailUrl,
      'source': instance.source,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
      'needRotate': instance.needRotate,
      'crawledAt': instance.crawledAt.toIso8601String(),
    };
