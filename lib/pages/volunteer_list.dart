import 'package:flutter/material.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';

class Volunteer_List extends StatefulWidget {
  const Volunteer_List({super.key});
  @override
  State createState() => _Volunteer_ListState();
}

class _Volunteer_ListState extends State<Volunteer_List> {
  // 현재 페이지를 트래킹하려면 ListView 대신 PageView가 필요합니다.
  final PageController pageController = PageController();
  int currentPage = 0;
  String selectedFilter = "전체"; // 초기값을 드롭다운 아이템 중 하나로 설정

  @override
  void dispose() {
    // 컨트롤러 해제
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 2, // 하단 네비게이션바에서 자원봉사 탭을 선택
      ),
      backgroundColor: Colors.white,
      appBar: BaseAppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                child: Row(
                  children: [
                    Text(
                      "전체",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.tune),
                onPressed: () async {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject()
                          as RenderBox;
                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(Offset.zero, ancestor: overlay),
                      button.localToGlobal(
                        button.size.bottomRight(Offset.zero),
                        ancestor: overlay,
                      ),
                    ),
                    Offset.zero & Size(button.size.width, 0),
                  );
                  final String? selected = await showMenu<String>(
                    context: context,
                    position: position,
                    items: <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(value: '전체', child: Text('전체')),
                      PopupMenuItem<String>(value: '강남구', child: Text('마포구')),
                      PopupMenuItem<String>(value: '강동구', child: Text('동대문센터')),
                    ],
                  );
                  if (selected != null) {
                    setState(() {
                      selectedFilter = selected;
                    });
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              height: 500,
              child: ListView.separated(
                itemCount: 10, // 실제 데이터 개수에 맞게 변경
                separatorBuilder: (BuildContext context, int idx) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (BuildContext context, int idx) {
                  return ListTile(
                    title: Text('자원봉사 모집'),
                    subtitle: Text('서울시 마포구 동교동 123-45'),
                    leading: Icon(Icons.person),
                    trailing: Icon(Icons.arrow_forward_ios),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
