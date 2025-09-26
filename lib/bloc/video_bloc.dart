import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/video_service.dart';
import 'video_event.dart';
import 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoService _videoService;

  VideoBloc(this._videoService) : super(VideoInitial()) {
    on<LoadVideos>(_onLoadVideos);
    on<RefreshVideos>(_onRefreshVideos);
    on<SearchVideos>(_onSearchVideos);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadVideos(
    LoadVideos event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoLoading());
    try {
      final videos = await _videoService.fetchVideos();
      emit(VideoLoaded(videos, allVideos: videos));
    } catch (e) {
      emit(VideoError(e.toString().replaceFirst("Exception:", "")));
    }
  }

  Future<void> _onRefreshVideos(
    RefreshVideos event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoLoading());
    try {
      final videos = await _videoService.fetchVideos();
      emit(VideoLoaded(videos, allVideos: videos));
    } catch (e) {
      emit(VideoError(e.toString().replaceFirst("Exception:", "")));
    }
  }

  void _onSearchVideos(
    SearchVideos event,
    Emitter<VideoState> emit,
  ) {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(currentState.copyWith(
          videos: currentState.allVideos,
          searchQuery: '',
        ));
      } else {
        final filteredVideos = currentState.allVideos.where((video) {
          return video.title.toLowerCase().contains(query) ||
              (video.description?.toLowerCase().contains(query) ?? false);
        }).toList();

        emit(currentState.copyWith(
          videos: filteredVideos,
          searchQuery: query,
        ));
      }
    }
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<VideoState> emit,
  ) {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      emit(currentState.copyWith(
        videos: currentState.allVideos,
        searchQuery: '',
      ));
    }
  }
}
