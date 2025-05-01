import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:meongjup/api/dog_dto.dart';
import 'package:meongjup/api/missing_dto.dart';
import 'package:meongjup/api/volunteer_dto.dart';
import 'package:meongjup/pages/adoption_list.dart';
import 'package:meongjup/pages/missing_detail.dart';
import 'package:meongjup/pages/puppyfeed_list.dart';
import 'package:meongjup/pages/volunteer_list.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/adoptionPuppyAtMain.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/volunteer_post.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final ScrollController _scrollController = ScrollController();
  DogDtoList? adoptionDogdata;
  Map<String, List<String>> imageList = {};
  List<MissingDto> missingDatas = [];
  List<Uint8List?>? thumbnails;
  List<VolunteerDto> volunteerDatas = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    getMissingDatas();
    fetch();
    getVolunteerDatas();

    FlutterNativeSplash.remove(); // Remove splash screen after delay
  }

  Future<void> getMissingDatas() async {
    try {
      final db = FirebaseFirestore.instance;
      final querySnapshot = await db.collection("missing").get();
      if (!mounted) return;
      setState(() {
        missingDatas =
            querySnapshot.docs
                .map((doc) => MissingDto.fromJson(doc.data()))
                .toList();
        thumbnails = List.filled(missingDatas.length, null);
      });
      getThumbnail();
    } catch (e) {
      debugPrint("Error getting document: $e");
    }
  }

  Future<void> getThumbnail() async {
    if (thumbnails == null) return;
    final storageRef = FirebaseStorage.instance.ref();

    for (var i = 0; i < missingDatas.length; i++) {
      final islandRef = storageRef.child(missingDatas[i].images[0]);
      try {
        const oneMegabyte = 1024 * 1024;
        final Uint8List? thumbnail = await islandRef.getData(oneMegabyte);
        if (!mounted) return;
        setState(() {
          thumbnails![i] = thumbnail;
        });
      } on FirebaseException catch (e) {
        debugPrint("Error getting document: $e");
      }
    }
  }

  Future<void> fetch() async {
    String src =
        'http://openapi.seoul.go.kr:8088/435a79586c62616b38344e72746d47/json/TbAdpWaitAnimalView/1/1000';
    if (!mounted) return;
    try {
      final res = await http.get(Uri.parse(src));
      if (res.statusCode == 200) {
        setState(() {
          adoptionDogdata = DogDtoList.fromJson(
            jsonDecode(res.body)['TbAdpWaitAnimalView'],
          );
        });
        await fetchImage();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchImage() async {
    String src =
        'http://openapi.seoul.go.kr:8088/435a79586c62616b38344e72746d47/json/TbAdpWaitAnimalPhotoView/1/1000/';
    try {
      final res = await http.get(Uri.parse(src));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body)['TbAdpWaitAnimalPhotoView']['row'];

        for (var element in adoptionDogdata!.dogs) {
          imageList[element.ANIMAL_NO] = [];
          for (var i = 0; i < data.length; i++) {
            if (element.ANIMAL_NO == data[i]['ANIMAL_NO']) {
              if (data[i]['PHOTO_KND'] == 'IMG') {
                imageList[data[i]['ANIMAL_NO']]?.add(data[i]['PHOTO_URL']);
                break;
              }
            }
          }
        }
        setState(() {
          imageList;
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getVolunteerDatas() async {
    try {
      final db = FirebaseFirestore.instance;
      final querySnapshot =
          await db.collection("봉사활동").limit(3).get(); // limit 추가
      setState(() {
        volunteerDatas =
            querySnapshot.docs
                .map((doc) => VolunteerDto.fromJson(doc.data()))
                .toList();
      });
    } catch (e) {
      debugPrint("Error getting document: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 148,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/alertMissingChildrenBanner.png',
                      ),
                      SizedBox(height: 12),
                      missingDatas.isNotEmpty && thumbnails != null
                          ? Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemCount: missingDatas.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => MissingDetail(
                                                    distinction:
                                                        missingDatas[index]
                                                            .distinction,
                                                    species:
                                                        missingDatas[index]
                                                            .species,
                                                    name:
                                                        missingDatas[index]
                                                            .name,
                                                    subject:
                                                        missingDatas[index]
                                                            .subject,
                                                    images:
                                                        missingDatas[index]
                                                            .images,
                                                    location:
                                                        missingDatas[index]
                                                            .location,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 40,
                                          child: ClipOval(
                                            child:
                                                thumbnails![index] != null
                                                    ? Image.memory(
                                                      thumbnails![index]!,
                                                      fit: BoxFit.cover,
                                                      width: 80,
                                                      height: 80,
                                                    )
                                                    : Container(
                                                      color: Colors.grey,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        missingDatas[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                          : Container(
                            height: 100,
                            child: Center(child: Text('데이터가 없습니다')),
                          ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 12),
                          Text(
                            '입양하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AdoptionList(),
                                ),
                              );
                            },
                            child: Text(
                              '자세히보기 >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      adoptionDogdata != null && imageList.isNotEmpty
                          ? Container(
                            height: 160,
                            child: PageView(
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              children: [
                                AdoptionPuppyAtMain(
                                  index: 0,
                                  ANIMAL_NO: adoptionDogdata!.dogs[0].ANIMAL_NO,
                                  url:
                                      imageList[adoptionDogdata!
                                              .dogs[0]
                                              .ANIMAL_NO]![0]
                                          .toString(),
                                  NM: adoptionDogdata!.dogs[0].NM,
                                  BREEDS: adoptionDogdata!.dogs[0].BREEDS,
                                  AGE: adoptionDogdata!.dogs[0].AGE,
                                  BDWGH: adoptionDogdata!.dogs[0].BDWGH,
                                  SEXDSTN: adoptionDogdata!.dogs[0].SEXDSTN,
                                ),
                                AdoptionPuppyAtMain(
                                  index: 1,
                                  ANIMAL_NO: adoptionDogdata!.dogs[1].ANIMAL_NO,
                                  url:
                                      imageList[adoptionDogdata!
                                              .dogs[1]
                                              .ANIMAL_NO]![0]
                                          .toString(),
                                  NM: adoptionDogdata!.dogs[1].NM,
                                  BREEDS: adoptionDogdata!.dogs[1].BREEDS,
                                  AGE: adoptionDogdata!.dogs[1].AGE,
                                  BDWGH: adoptionDogdata!.dogs[1].BDWGH,
                                  SEXDSTN: adoptionDogdata!.dogs[1].SEXDSTN,
                                ),
                                AdoptionPuppyAtMain(
                                  index: 2,
                                  ANIMAL_NO: adoptionDogdata!.dogs[2].ANIMAL_NO,
                                  url:
                                      imageList[adoptionDogdata!
                                              .dogs[2]
                                              .ANIMAL_NO]![0]
                                          .toString(),
                                  NM: adoptionDogdata!.dogs[2].NM,
                                  BREEDS: adoptionDogdata!.dogs[2].BREEDS,
                                  AGE: adoptionDogdata!.dogs[2].AGE,
                                  BDWGH: adoptionDogdata!.dogs[2].BDWGH,
                                  SEXDSTN: adoptionDogdata!.dogs[2].SEXDSTN,
                                ),
                              ],
                            ),
                          )
                          : AdoptionPuppyAtMain(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentPage == index
                                      ? Colors.black
                                      : Colors.grey[300],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 12),
                          Text(
                            '자원봉사',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VolunteerList(),
                                ),
                              );
                            },
                            child: Text(
                              '자세히보기 >',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      volunteerDatas.isNotEmpty
                          ? Column(
                            children: [
                              VolunteerPost(
                                activity_period:
                                    volunteerDatas[0].activity_period,
                                activity_time: volunteerDatas[0].activity_time,
                                content: volunteerDatas[0].content,
                                location: volunteerDatas[0].location,
                                subject: volunteerDatas[0].subject,
                                period: volunteerDatas[0].period,
                                personnel: volunteerDatas[0].personnel,
                                target: volunteerDatas[0].target,
                              ),
                              VolunteerPost(
                                activity_period:
                                    volunteerDatas[1].activity_period,
                                activity_time: volunteerDatas[1].activity_time,
                                content: volunteerDatas[1].content,
                                location: volunteerDatas[1].location,
                                subject: volunteerDatas[1].subject,
                                period: volunteerDatas[1].period,
                                personnel: volunteerDatas[1].personnel,
                                target: volunteerDatas[1].target,
                              ),
                              VolunteerPost(
                                activity_period:
                                    volunteerDatas[2].activity_period,
                                activity_time: volunteerDatas[2].activity_time,
                                content: volunteerDatas[2].content,
                                location: volunteerDatas[2].location,
                                subject: volunteerDatas[2].subject,
                                period: volunteerDatas[2].period,
                                personnel: volunteerDatas[2].personnel,
                                target: volunteerDatas[2].target,
                              ),
                            ],
                          )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 12),
                          Text(
                            '멍피드',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PuppyFeedList(idx: 0),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height:
                                  MediaQuery.of(context).size.width *
                                  0.22 *
                                  16 /
                                  9,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/images/pupShort1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PuppyFeedList(idx: 1),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height:
                                  MediaQuery.of(context).size.width *
                                  0.22 *
                                  16 /
                                  9,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/images/pupShort2.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PuppyFeedList(idx: 2),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height:
                                  MediaQuery.of(context).size.width *
                                  0.22 *
                                  16 /
                                  9,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/images/pupShort3.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PuppyFeedList(idx: 3),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height:
                                  MediaQuery.of(context).size.width *
                                  0.22 *
                                  16 /
                                  9,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/images/pupShort4.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
