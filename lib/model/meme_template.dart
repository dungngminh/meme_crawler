import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meme_template.g.dart';

@JsonSerializable()
class MemeTemplate extends Equatable {
  final String id;
  final String title;
  final String originalImageUrl;
  final String detailUrl;
  final String? source;
  final int? imageWidth;
  final int? imageHeight;
  final bool? needRotate;
  final DateTime crawledAt;
  MemeTemplate({
    required this.id,
    required this.title,
    required this.originalImageUrl,
    required this.detailUrl,
    this.source,
    required this.crawledAt,
    this.imageWidth,
    this.imageHeight,
    this.needRotate,
  });

  factory MemeTemplate.fromJson(Map<String, dynamic> json) =>
      _$MemeTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$MemeTemplateToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      title,
      originalImageUrl,
      detailUrl,
      source,
      crawledAt,
      imageWidth,
      imageHeight,
      needRotate,
    ];
  }
}
