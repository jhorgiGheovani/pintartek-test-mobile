import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video_bloc.dart';
import '../bloc/video_event.dart';
import '../bloc/video_state.dart';
import '../models/video.dart';
import '../widgets/video_card.dart';
import 'video_player_screen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(LoadVideos());

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<VideoBloc>().add(SearchVideos(query));
    setState(() {});
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchActive = _searchFocusNode.hasFocus;
      if (_isSearchActive) {
        _searchAnimationController.forward();
      } else if (_searchController.text.isEmpty) {
        _searchAnimationController.reverse();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<VideoBloc>().add(ClearSearch());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF8FAFF),
              const Color(0xFFFFF4E6),
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoading) {
              return _buildLoadingState();
            } else if (state is VideoLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  HapticFeedback.lightImpact();
                  context.read<VideoBloc>().add(RefreshVideos());
                },
                color: Colors.orange.shade400,
                backgroundColor: Colors.white,
                strokeWidth: 3,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 180,
                      floating: false,
                      pinned: false,
                      snap: false,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.shade50.withOpacity(0.8),
                                Colors.pink.shade50.withOpacity(0.6),
                                Colors.white.withOpacity(0.4),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 34,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.orange.shade400,
                                                  Colors.pink.shade400,
                                                  Colors.red.shade400,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                stops: const [0.0, 0.6, 1.0],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.5),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 8),
                                                ),
                                                BoxShadow(
                                                  color: Colors.pink
                                                      .withOpacity(0.3),
                                                  blurRadius: 12,
                                                  offset: const Offset(4, 4),
                                                ),
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  blurRadius: 6,
                                                  offset: const Offset(-2, -2),
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ShaderMask(
                                              shaderCallback: (bounds) =>
                                                  LinearGradient(
                                                colors: [
                                                  Colors.orange.shade600,
                                                  Colors.pink.shade600,
                                                  Colors.purple.shade600,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds),
                                              child: Text(
                                                'Pintartek Video Platform',
                                                style: theme
                                                    .textTheme.headlineMedium
                                                    ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: -0.8,
                                                  height: 1.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildSearchBar(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state.searchQuery.isNotEmpty && state.videos.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildNoSearchResults(state.searchQuery),
                      )
                    else if (state.searchQuery.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _buildSearchResultsHeader(
                            state.videos.length, state.searchQuery),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final video = state.videos[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: VideoCard(
                                video: video,
                                onTap: () => _navigateToPlayer(context, video),
                              ),
                            );
                          },
                          childCount: state.videos.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 40),
                    ),
                  ],
                ),
              );
            } else if (state is VideoError) {
              return _buildErrorState(state.message);
            }
            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  void _navigateToPlayer(BuildContext context, Video video) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VideoPlayerScreen(video: video),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8FAFF),
            const Color(0xFFFFF4E6),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.orange.shade50.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(-4, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
                strokeWidth: 4,
                backgroundColor: Colors.orange.shade100,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Loading videos...',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wait a second, still preparing the content!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.shade50,
            Colors.orange.shade50.withOpacity(0.4),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.red.shade50.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(-4, 4),
                  ),
                ],
              ),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Oppsss! There is some problem',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 12),
            // Text(
            //   message,
            //   textAlign: TextAlign.center,
            //   style: theme.textTheme.bodyLarge?.copyWith(
            //     color: Colors.black.withOpacity(0.6),
            //     height: 1.5,
            //   ),
            // ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<VideoBloc>().add(LoadVideos());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                label: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.pink.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh_rounded,
                            size: 22, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Coba Lagi',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8FAFF),
            const Color(0xFFFFF4E6),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.orange.shade50.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(-6, 6),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.video_collection_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 36),
            Text(
              'Belum Ada Video Nih',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Swipe down to refresh and find cool videos',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.6),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade200.withOpacity(0.2),
                    Colors.pink.shade200.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade400, Colors.pink.shade400],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Pull to refresh',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedBuilder(
      animation: _searchAnimation,
      builder: (context, child) {
        return Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.orange.shade50.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: _isSearchActive
                  ? Colors.orange.shade400.withOpacity(0.6)
                  : Colors.white.withOpacity(0.4),
              width: _isSearchActive ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isSearchActive
                    ? Colors.orange.withOpacity(0.25)
                    : Colors.black.withOpacity(0.08),
                blurRadius: _isSearchActive ? 16 : 12,
                offset: Offset(0, _isSearchActive ? 6 : 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Cari video yang lo mau...',
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400.withOpacity(0.8),
                      Colors.pink.shade400.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _clearSearch,
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                HapticFeedback.lightImpact();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchResultsHeader(int count, String query) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50.withOpacity(0.8),
            Colors.cyan.shade50.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.cyan.shade400],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(text: 'Ditemukan '),
                  TextSpan(
                    text: '$count video',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  TextSpan(text: ' untuk "'),
                  TextSpan(
                    text: query,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  TextSpan(text: '"'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults(String query) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade50,
            Colors.blue.shade50.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Video tidak tersedia',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.6),
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'Video dengan kata kunci "'),
                TextSpan(
                  text: query,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade700,
                  ),
                ),
                TextSpan(text: '" tidak ada. Coba kata kunci lain!'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
