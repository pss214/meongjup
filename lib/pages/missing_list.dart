import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/api/missing_dto.dart';
import 'package:meongjup/api/witnessing_dto.dart';
import 'package:meongjup/pages/witnessing_post.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/missing_puppy.dart';
import 'package:meongjup/pages/missing_post.dart';
import 'package:meongjup/widgets/witnessing_puppy.dart';

class MissingList extends StatefulWidget {
  const MissingList({super.key});
  @override
  State createState() => _MissingList();
}

class _MissingList extends State<MissingList> {
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
    getWitnessingDatas();
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

  List<WitnessingDto> witnessingDatas = [];
  Future<void> getWitnessingDatas() async {
    try {
      final db = FirebaseFirestore.instance;
      final querySnapshot = await db.collection("witnessing").get();
      setState(() {
        witnessingDatas =
            querySnapshot.docs
                .map((doc) => WitnessingDto.fromJson(doc.data()))
                .toList();
      });
    } catch (e) {
      debugPrint("Error getting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WitnessingPost(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/witness_writing.png',
                            fit: BoxFit.cover,
                            width: deviceWidth / 2 - 9,
                          ),
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
                        missingDatas.isNotEmpty
                            ? SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: missingDatas.length,
                                itemBuilder: (context, index) {
                                  return MissingPuppy(
                                    distinction:
                                        missingDatas[index].distinction,
                                    species: missingDatas[index].species,
                                    name: missingDatas[index].name,
                                    subject: missingDatas[index].subject,
                                    images: missingDatas[index].images,
                                    location: missingDatas[index].location,
                                  );
                                },
                              ),
                            )
                            : SizedBox(
                              width: double.infinity,
                              child: Center(child: Text('데이터가 없습니다')),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WitnessingPost(),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/witness_writing.png',
                            fit: BoxFit.cover,
                            width: deviceWidth / 2 - 9,
                          ),
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
                              '길 잃은 강아지 주인을 찾습니다 >',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        witnessingDatas.isNotEmpty
                            ? SizedBox(
                              width: double.infinity,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: witnessingDatas.length,
                                itemBuilder: (context, index) {
                                  return WitnessingPuppy(
                                    distinction:
                                        witnessingDatas[index].distinction,
                                    species: witnessingDatas[index].species,
                                    name: witnessingDatas[index].name,
                                    subject: witnessingDatas[index].subject,
                                    images: witnessingDatas[index].images,
                                    location: witnessingDatas[index].location,
                                  );
                                },
                              ),
                            )
                            : SizedBox(
                              width: double.infinity,
                              child: Center(child: Text('데이터가 없습니다')),
                            ),
                      ],
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
}
