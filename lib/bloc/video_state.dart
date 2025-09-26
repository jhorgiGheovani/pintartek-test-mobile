import 'package:equatable/equatable.dart';
import '../models/video.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<Video> videos;
  final List<Video> allVideos;
  final String searchQuery;

  const VideoLoaded(
    this.videos, {
    this.allVideos = const [],
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [videos, allVideos, searchQuery];

  VideoLoaded copyWith({
    List<Video>? videos,
    List<Video>? allVideos,
    String? searchQuery,
  }) {
    return VideoLoaded(
      videos ?? this.videos,
      allVideos: allVideos ?? this.allVideos,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class VideoError extends VideoState {
  final String message;

  const VideoError(this.message);

  @override
  List<Object> get props => [message];
}

class SingleVideoLoaded extends VideoState {
  final Video video;

  const SingleVideoLoaded(this.video);

  @override
  List<Object> get props => [video];
}
