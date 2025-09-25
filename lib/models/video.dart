import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video extends Equatable {
  final String id;
  final String title;
  final String videoUrl;
  final String? description;
  final String? thumbnailUrl;
  final int? duration;

  const Video({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.description,
    this.thumbnailUrl,
    this.duration,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        videoUrl,
        description,
        thumbnailUrl,
        duration,
      ];
}
