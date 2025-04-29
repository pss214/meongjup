import 'package:flutter/material.dart';
import 'package:meongjup/pages/adoption_list.dart';
import 'package:meongjup/pages/missing_list.dart';
import 'package:meongjup/pages/puppyfeed_list.dart';
import 'package:meongjup/pages/volunteer_list.dart';

//하단 홈, 실종, 자원봉사, 멍피드 탭바 생성
class BottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigation({super.key, required this.selectedIndex});

  void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Missing_list()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Volunteer_List()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PuppyFeedList()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffeeeeee), width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon:
                        selectedIndex == 0
                            ? Image.asset(
                              'assets/images/home.png',
                              width: 24,
                              height: 24,
                            )
                            : Image.asset(
                              'assets/images/home_1.png',
                              width: 24,
                              height: 24,
                            ),
                    onPressed: () => navigateToPage(context, 0),
                  ),
                  Text('입양', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon:
                        selectedIndex == 1
                            ? Image.asset(
                              'assets/images/icon2.png',
                              width: 24,
                              height: 24,
                            )
                            : Image.asset(
                              'assets/images/icon2_1.png',
                              width: 24,
                              height: 24,
                            ),
                    onPressed: () => navigateToPage(context, 1),
                  ),
                  Text('실종', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon:
                        selectedIndex == 2
                            ? Image.asset(
                              'assets/images/icon3.png',
                              width: 24,
                              height: 24,
                            )
                            : Image.asset(
                              'assets/images/icon3_1.png',
                              width: 24,
                              height: 24,
                            ),
                    onPressed: () => navigateToPage(context, 2),
                  ),
                  Text('자원봉사', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon:
                        selectedIndex == 3
                            ? Image.asset(
                              'assets/images/icon4.png',
                              width: 24,
                              height: 24,
                            )
                            : Image.asset(
                              'assets/images/icon4_1.png',
                              width: 24,
                              height: 24,
                            ),
                    onPressed: () => navigateToPage(context, 3),
                  ),
                  Text('멍피드', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
