import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class LoadVideos extends VideoEvent {}

class LoadVideoById extends VideoEvent {
  final String videoId;

  const LoadVideoById(this.videoId);

  @override
  List<Object> get props => [videoId];
}

class RefreshVideos extends VideoEvent {}
