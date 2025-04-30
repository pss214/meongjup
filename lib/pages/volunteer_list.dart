import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/api/volunteer_dto.dart';
import 'package:meongjup/pages/volunteer_detail.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';

class VolunteerList extends StatefulWidget {
  const VolunteerList({super.key});

  @override
  State createState() => _VolunteerListState();
}

class _VolunteerListState extends State<VolunteerList> {
  final PageController pageController = PageController();
  String selectedFilter = "전체"; // 초기값을 드롭다운 아이템 중 하나로 설정
  List<VolunteerDto> volunteerDatas = []; //자원봉사 리스트 데이터

  @override
  void initState() {
    //페이지 컨트롤러 초기화
    super.initState();
    getVolunteerDatas();
  }

  Future<void> getVolunteerDatas() async {
    try {
      final db = FirebaseFirestore.instance;
      final querySnapshot = await db.collection("봉사활동").get();
      setState(() {
        volunteerDatas =
            querySnapshot.docs
                .map((doc) => VolunteerDto.fromJson(doc.data()))
                .toList();
      });
      debugPrint(volunteerDatas.toString());
    } catch (e) {
      debugPrint("Error getting document: $e");
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제=페이지 사라질 때 호출되는 함수, 리소스 정리할 때 씀
    pageController.dispose(); //메모리에서 정리
    super.dispose(); //부모 클래스의 dispose 호출
  }

  List<VolunteerDto> getfilteredVolunteerList() {
    if (selectedFilter == "전체") {
      return volunteerDatas;
    }

    return volunteerDatas
        .where((test) => test.location.contains(selectedFilter))
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
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        selectedFilter,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                            value: '마포', //필터에서 마포 선택했을 때 페이지에 입력되는 값
                            child: Text('마포'), //필터에서 마포 선택했을 때 필터에 표시되는 텍스트
                          ),
                          PopupMenuItem<String>(
                            value: '동대문', //필터에서 동대문 선택했을 때 페이지에 입력되는 값
                            child: Text('동대문'), //필터에서 동대문 선택했을 때 표시되는 텍스트
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
              itemCount: getfilteredVolunteerList().length,
              itemBuilder: (context, index) {
                return ListView.separated(
                  itemCount: getfilteredVolunteerList().length,
                  separatorBuilder:
                      (BuildContext context, int idx) => Divider(),
                  itemBuilder: (BuildContext context, int idx) {
                    return ListTile(
                      title: Text(getfilteredVolunteerList()[idx].subject),
                      subtitle: Text(getfilteredVolunteerList()[idx].location),
                      onTap:
                          () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => VolunteerDetail(
                                      activity_period:
                                          getfilteredVolunteerList()[idx]
                                              .activity_period,
                                      activity_time:
                                          getfilteredVolunteerList()[idx]
                                              .activity_time,
                                      content:
                                          getfilteredVolunteerList()[idx]
                                              .content,
                                      location:
                                          getfilteredVolunteerList()[idx]
                                              .location,
                                      subject:
                                          getfilteredVolunteerList()[idx]
                                              .subject,
                                      period:
                                          getfilteredVolunteerList()[idx]
                                              .period,
                                      personnel:
                                          getfilteredVolunteerList()[idx]
                                              .personnel,
                                      target:
                                          getfilteredVolunteerList()[idx]
                                              .target,
                                    ),
                              ),
                            ),
                          },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
