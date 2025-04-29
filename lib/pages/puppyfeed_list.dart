import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//여기까지 중간지점으로

class PuppyFeedList extends StatefulWidget {
  const PuppyFeedList({super.key});

  @override
  State<PuppyFeedList> createState() => _PuppyFeedListState();
}

class _PuppyFeedListState extends State<PuppyFeedList> {
  final List<String> _videoIds = [
    'OkJtwjuKfjk',
    '56Bw2sgUd6M',
    'MZ18RH3k18E',
    'QTz-wrCthds',
    'IvOlYCc5sWg',
    'YaW_8yYM-ZU',
    'YVLuiKZAykM',
  ];
  List<int> _likes = [];
  List<double> _scaleFactors = []; // 애니메이션용 scale 값 추가

  late PageController _pageController; // 세로 페이지 컨트롤러
  late int _currentPage = 0; // 현재 페이지 인덱스
  Map<int, YoutubePlayerController> _controllers =
      {}; // 각 페이지에 해당하는 유튜브 컨트롤러 저장소
  bool _isLoading = false; // 중복 로딩 방지 플래그

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      keepPage: true,
      initialPage: 0,
    );
    _likes = List.generate(_videoIds.length, (_) => 0);
    _scaleFactors = List.generate(_videoIds.length, (_) => 1.0); // 🔥 반드시 초기화
    _initializeController(0);
  }

  // 특정 인덱스의 유튜브 컨트롤러를 생성
  void _initializeController(int index) {
    if (index >= 0 &&
        index < _videoIds.length &&
        !_controllers.containsKey(index)) {
      _controllers[index] = YoutubePlayerController(
        initialVideoId: _videoIds[index],
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
          forceHD: false,
          loop: true, // 반복 재생 활성화
          isLive: false,
          disableDragSeek: true,
          useHybridComposition: true, // Android에서 WebView 성능 개선 (기기 따라 차이 있음)
        ),
      );
    }
  }

  // 현재 페이지(index)를 중심으로 이전(index - 1), 다음(index + 1) 페이지까지 컨트롤러를 미리 초기화
  void _initializeSurroundingControllers(int index) {
    for (int i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < _videoIds.length) {
        _initializeController(i); // 이미 초기화된 경우는 내부에서 무시됨
      }
    }
  }

  // 현재 페이지(index)의 이전/다음만 유지하고 그 외의 컨트롤러는 제거하여 메모리 절약
  void _cleanupControllers(int currentIndex) {
    final keysToRemove = <int>[];
    _controllers.forEach((key, controller) {
      if (key < currentIndex - 1 || key > currentIndex + 1) {
        controller.dispose();
        keysToRemove.add(key);
      }
    });
    keysToRemove.forEach(_controllers.remove);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(selectedIndex: 3),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: _videoIds.length,
        onPageChanged: (index) async {
          if (_isLoading) return;

          setState(() {
            _isLoading = true;
            _currentPage = index;
          });

          try {
            _initializeSurroundingControllers(index);
            _cleanupControllers(index);

            for (var entry in _controllers.entries) {
              if (entry.key == index) {
                entry.value.play();
              } else {
                entry.value.pause();
              }
            }
          } finally {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        },
        itemBuilder: (context, index) {
          if (!_controllers.containsKey(index) ||
              _likes.length <= index ||
              _scaleFactors.length <= index) {
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          return Container(
            color: Colors.black,
            child: Stack(
              children: [
                YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controllers[index]!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                  ),
                  builder: (context, player) {
                    return Stack(
                      children: [
                        Positioned.fill(child: player),
                        Positioned(
                          bottom: 35,
                          right: 16,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _likes[index] =
                                        (_likes[index] + 1) % 2; // 좋아요 토글
                                    _scaleFactors[index] = 1.5;
                                  });

                                  Future.delayed(
                                    const Duration(milliseconds: 150),
                                    () {
                                      if (mounted) {
                                        setState(() {
                                          _scaleFactors[index] = 1.0;
                                        });
                                      }
                                    },
                                  );
                                },
                                child: AnimatedScale(
                                  scale: _scaleFactors[index],
                                  duration: const Duration(milliseconds: 150),
                                  child: Icon(
                                    _likes[index] == 1
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
