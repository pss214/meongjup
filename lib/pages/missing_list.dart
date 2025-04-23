import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Missing_list extends StatefulWidget {
  const Missing_list({super.key});
  @override
  State createState() => _Missing_list();
}

class _Missing_list extends State<Missing_list> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width; // 디바이스 너비
    double deviceHeight = MediaQuery.of(context).size.height; // 디바이스 높이

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pets), text: "실종"),
              Tab(icon: Icon(Icons.search), text: "목격"),
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: 190,
                  child: Center(child: Text("실종 신고하기")),
                ),
                Container(
                  height: 140,
                  width: 190,
                  child: Center(child: Text("목격 제보하기")),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2, // 실종 리스트 아이템 비율 숫자가 커질수록 짧아짐
                    padding: EdgeInsets.all(10),
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1),
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      'https://animal.seoul.go.kr/comm/getImage?srvcId=MEDIA&upperNo=4224&fileTy=ADOPTIMG&fileNo=1&thumbTy=L',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '화성시 병점동',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "이름: 초코 / 견종: 웰시코기",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("특징: 목걸이를 끊어버리고 도망갔어요."),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 5,
                    padding: EdgeInsets.all(2),
                    children: List.generate(1, (index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(1),
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      'https://animal.seoul.go.kr/comm/getImage?srvcId=MEDIA&upperNo=4224&fileTy=ADOPTIMG&fileNo=1&thumbTy=L',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '화성시 병점동',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Column(
                                children: [
                                  Text(
                                    "목격 시간: 오후 3시경",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("특징: 웰시코기로 보이는 강아지가 혼자 돌아다니는 것을 봤어요"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
