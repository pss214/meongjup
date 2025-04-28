import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    'YVLuiKZAykM'
  ];

  late PageController _pageController;
  late int _currentPage = 0;
  Map<int, YoutubePlayerController> _controllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      keepPage: true,
      initialPage: 0
    );
    // 첫 번째 컨트롤러만 초기화
    _initializeController(0);
  }

  // 단일 컨트롤러 초기화 함수
  void _initializeController(int index) {
    if (index >= 0 && index < _videoIds.length && !_controllers.containsKey(index)) {
      _controllers[index] = YoutubePlayerController(
        initialVideoId: _videoIds[index],
        flags: YoutubePlayerFlags(
          autoPlay: true, // 자동재생 활성화
          mute: false,
          enableCaption: false,
          forceHD: false,
          loop: false,
          isLive: false,
          disableDragSeek: true,
        ),
      );
    }
  }

  void _cleanupControllers(int currentIndex) {
    _controllers.removeWhere((key, controller) {
      if (key != currentIndex) {
        controller.dispose();
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
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

          // 현재 페이지의 컨트롤러 초기화
          _initializeController(index);
          // 이전 컨트롤러들 정리
          _cleanupControllers(index);

          setState(() {
            _isLoading = false;
          });
        },
        itemBuilder: (context, index) {
          if (!_controllers.containsKey(index)) {
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                )
              )
            );
          }
          
          return Container(
            color: Colors.black,
            child: YoutubePlayer(
              controller: _controllers[index]!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              progressColors: const ProgressBarColors(
                playedColor: Colors.red,
                handleColor: Colors.redAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}