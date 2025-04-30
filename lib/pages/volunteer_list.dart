import 'package:flutter/material.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';

class Volunteer_List extends StatefulWidget {
  const Volunteer_List({super.key});

  @override
  State createState() => _Volunteer_ListState();
}

class _Volunteer_ListState extends State<Volunteer_List> {
  final PageController pageController = PageController();
  int currentPage = 0;
  int totalPages = 3;
  String selectedFilter = "전체"; // 초기값을 드롭다운 아이템 중 하나로 설정

  @override
  void initState() {
    //페이지 컨트롤러 초기화
    super.initState();
    pageController.addListener(() {
      //페이지 컨트롤러 리스너 추가
      setState(() {
        //상태 변경
        currentPage = pageController.page?.toInt() ?? 0; //현재 페이지 업데이트
      });
    });
  }

  @override
  void dispose() {
    // 컨트롤러 해제=페이지 사라질 때 호출되는 함수, 리소스 정리할 때 씀
    pageController.dispose(); //메모리에서 정리
    super.dispose(); //부모 클래스의 dispose 호출
  }

  void moveToPage(int page) {
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page;
      });
      pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  final List<Map<String, String>> volunteerList = [
    {'title': '자원봉사 모집', 'location': '마포구'},
    {'title': '나나나ㅏ나나나난 환경 봉사', 'location': '마포구'},
    {'title': 'ㄹ루루루루루루 봉사', 'location': '동대문센터'},
    {'title': '캬캬캬 청소 봉사', 'location': '마포구'},
    {'title': '가가가 청소 봉사', 'location': '마포구'},
    {'title': '나나나 청소 봉사', 'location': '마포구'},
    {'title': '하하하 봉사', 'location': '동대문센터'},
    {'title': '호호호센터 봉사', 'location': '동대문센터'},
    {'title': '파파파센터 봉사', 'location': '동대문센터'},
  ];
  //임시 데이터이이이이이이이이ㅣ임미다~!!!!~!!!!!!!!!!!!!!!!!!!!!!

  List<Map<String, String>> getfilteredVolunteerList() {
    if (selectedFilter == "전체") {
      return volunteerList;
    }
    return volunteerList
        .where(
          (volunteer) =>
              volunteer['location']?.contains(selectedFilter) ?? false,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    //화면에 그릴 내용 작성
    return Scaffold(
      //화면 전체 구성
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
              SizedBox(
                width: 200,
                child: Row(
                  children: [
                    Text(
                      selectedFilter,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: () async {
                      //버튼을 누르면 필터 선택 가능한 팝업을 띄움
                      final RenderBox button =
                          context.findRenderObject() as RenderBox; //버튼 위치 찾기
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox; //팝업 위치 찾기
                      final RelativeRect position = RelativeRect.fromRect(
                        //relativeRect 하나의 사각형이 다른 사각형에 대해 갖는 위치 정보 정의
                        //해당 위치는 offset값으로 정의
                        Rect.fromPoints(
                          button.localToGlobal(
                            Offset.zero,
                            ancestor: overlay,
                          ), //버튼 위치
                          button.localToGlobal(
                            button.size.bottomRight(Offset.zero), //버튼 오른쪽 아래 위치
                            ancestor: overlay, //부모 위젯
                          ),
                        ),
                        Offset.zero & Size(button.size.width, 0),
                      );
                      final String? selected = await showMenu<String>(
                        context: context,
                        position: position, //
                        items: <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(value: '전체', child: Text('전체')),
                          PopupMenuItem<String>(
                            value: '마포구', //필터에서 마포구 선택했을 때 페이지에 입력되는 값
                            child: Text('마포구'), //필터에서 마포구 선택했을 때 필터에 표시되는 텍스트
                          ),
                          PopupMenuItem<String>(
                            value: '동대문센터', //필터에서 동대문센터 선택했을 때 페이지에 입력되는 값
                            child: Text('동대문센터'), //필터에서 동대문센터 선택했을 때 표시되는 텍스트
                          ),
                        ], //selected에 유저가 고른 value값 저장
                      );
                      if (selected != null) {
                        setState(() {
                          selectedFilter =
                              selected; //선택된 값을 바꾸고 setstate() 호출하여 다시 그리기
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: totalPages,
              itemBuilder: (context, index) {
                final filteredList = getfilteredVolunteerList();
                final itemsPerPage = (filteredList.length / totalPages).ceil();
                final startIndex = index * itemsPerPage;
                final endIndex =
                    (startIndex + itemsPerPage) > filteredList.length
                        ? filteredList.length
                        : startIndex + itemsPerPage;
                final pageItems = filteredList.sublist(startIndex, endIndex);

                return ListView.separated(
                  itemCount: pageItems.length,
                  separatorBuilder:
                      (BuildContext context, int idx) => Divider(),
                  itemBuilder: (BuildContext context, int idx) {
                    return ListTile(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => VolunteerDetail(),
                      //     ),
                      //   );
                      // }, listtile 클릭 시 volunteer_detail페이지 이동
                      //목록 하나하나
                      title: Text(
                        getfilteredVolunteerList()[idx]['title'] ?? '',
                      ),
                      subtitle: Text(
                        getfilteredVolunteerList()[idx]['location'] ?? '',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    );
                  },
                );
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                return GestureDetector(
                  onTap: () => moveToPage(index),
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: currentPage == index ? Colors.blue : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
