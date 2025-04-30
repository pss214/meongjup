import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/api/missing_dto.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/missingPuppy.dart';
import 'package:meongjup/pages/missing_post.dart';

class Missing_list extends StatefulWidget {
  const Missing_list({super.key});
  @override
  State createState() => _Missing_list();
}

class _Missing_list extends State<Missing_list> {
  void _showMissingReportModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.asset(
            'assets/images/showMissingReportModalImage.png',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  List<MissingDto> missingDatas = [];
  @override
  void initState() {
    super.initState();
    getMissingDatas();
  }

  Future<void> getMissingDatas() async {
    try {
      final db = FirebaseFirestore.instance;
      final querySnapshot = await db.collection("missing").get();
      setState(() {
        missingDatas =
            querySnapshot.docs
                .map((doc) => MissingDto.fromJson(doc.data()))
                .toList();
      });
    } catch (e) {
      debugPrint("Error getting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(selectedIndex: 2),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leading: Image.asset(
            'assets/images/icon1.png',
            width: 24,
            height: 24,
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Color(0xFFFF7373),
            labelColor: Color(0xFFFF7373),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.pets, size: 12), text: "실종"),
              Tab(icon: Icon(Icons.search, size: 12), text: "목격"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 4),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MissingPost(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/missing_writing.png',
                            fit: BoxFit.cover,
                            width: deviceWidth / 2 - 9,
                          ),
                        ),
                        Image.asset(
                          'assets/images/witness_writing.png',
                          fit: BoxFit.cover,
                          width: deviceWidth / 2 - 9,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 4),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '실종된 아이를 찾습니다 >',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showMissingReportModal();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF7373),
                                padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Text(
                                '실종 신고하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: missingDatas.length,
                            itemBuilder: (context, index) {
                              return MissingPuppy(
                                distinction: missingDatas[index].distinction,
                                species: missingDatas[index].species,
                                name: missingDatas[index].name,
                                subject: missingDatas[index].subject,
                                images: missingDatas[index].images,
                                location: missingDatas[index].location,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/witness_writing.png',
                          width: 196,
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/missing_writing.png',
                          fit: BoxFit.cover,
                          width: 196,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      'https://animal.seoul.go.kr/comm/getImage?srvcId=MEDIA&upperNo=4224&fileTy=ADOPTIMG&fileNo=1&thumbTy=L',
                                      width: double.infinity,
                                      height: 140,
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
                              padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                              margin: EdgeInsets.only(top: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                    },
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
