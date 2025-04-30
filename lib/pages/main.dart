import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meongjup/api/dog_dto.dart';
import 'package:meongjup/api/missing_dto.dart';
import 'package:meongjup/pages/missing_detail.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/adoptionPuppy.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final ScrollController _scrollController = ScrollController();
  DogDtoList? dogdata;
  late final PagingController<int, DogDto> _pagingController = PagingController(
    getNextPageKey: _getNextPageKey,
    fetchPage: (pageKey) async => fetchData(pageKey),
  );
  Map<String, List<String>> imageList = {};
  List<MissingDto> missingDatas = [];
  List<Uint8List?>? thumbnails;

  @override
  void initState() {
    super.initState();
    getMissingDatas();
  }

  Future<void> getMissingDatas() async {
    try {
      final db = FirebaseFirestore.instance;
      final querySnapshot = await db.collection("missing").get();
      if (!mounted) return;
      setState(() {
        missingDatas = querySnapshot.docs
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

  int? _getNextPageKey(PagingState<int, DogDto> state) {
    try {
      final keys = state.keys;
      // Initial page key.
      if (keys == null) return 1;
      if (dogdata == null) {
        if (keys.last >= 15) return null;
      } else {
        if (keys.last < dogdata!.dogs.length) {
          return null;
        }
      }
      debugPrint(keys.last.toString());
      // Next page key.
      return keys.last + 1;
    } catch (e) {
      _pagingController.error;
      throw Exception(e);
    }
  }

  Future<List<DogDto>> fetchData(int page) async {
    try {
      if (dogdata == null) {
        await fetch();
      }
      return dogdata!.dogs.sublist(page);
    } catch (e) {
      _pagingController.error;
      throw Exception(e);
    }
  }

  Future<void> fetch() async {
    String src =
        'http://openapi.seoul.go.kr:8088/435a79586c62616b38344e72746d47/json/TbAdpWaitAnimalView/1/1000';
    try {
      final res = await http.get(Uri.parse(src));
      if (res.statusCode == 200) {
        setState(() {
          dogdata = DogDtoList.fromJson(
            jsonDecode(res.body)['TbAdpWaitAnimalView'],
          );
        });
        await fetchImage();
        _pagingController.refresh();
      } else {
        _pagingController.error;
      }
    } catch (e) {
      _pagingController.error;
    }
  }

  Future<void> fetchImage() async {
    String src =
        'http://openapi.seoul.go.kr:8088/435a79586c62616b38344e72746d47/json/TbAdpWaitAnimalPhotoView/1/1000/';
    try {
      final res = await http.get(Uri.parse(src));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body)['TbAdpWaitAnimalPhotoView']['row'];

        for (var element in dogdata!.dogs) {
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
      }
    } catch (e) {
      _pagingController.error;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 0),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '멍줍 소식 >',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  missingDatas.isNotEmpty && thumbnails != null ?
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: missingDatas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MissingDetail(
                                        distinction: missingDatas[index].distinction,
                                        species: missingDatas[index].species,
                                        name: missingDatas[index].name,
                                        subject: missingDatas[index].subject,
                                        images: missingDatas[index].images,
                                        location: missingDatas[index].location,
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  child: ClipOval(
                                    child: thumbnails![index] != null
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ) : Container(
                    height: 100,
                    child: Center(
                      child: Text('데이터가 없습니다'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(
                '입양을 기다리는 아이들 >',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => {fetch()},
              child: PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) {
                  return PagedListView<int, DogDto>(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    // 이 내부에서 높이 지정 X
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder:
                          (context, item, index) => AdoptionPuppy(
                            index: index,
                            ANIMAL_NO: item.ANIMAL_NO,
                            url: imageList[item.ANIMAL_NO]?[0] ?? '',
                            NM: item.NM,
                            BREEDS: item.BREEDS,
                            AGE: item.AGE,
                            BDWGH: item.BDWGH,
                            SEXDSTN: item.SEXDSTN,
                          ),
                      noItemsFoundIndicatorBuilder:
                          (_) => Center(child: Text('데이터가 없습니다')),
                      firstPageErrorIndicatorBuilder:
                          (_) => Center(child: Text('인터넷이 없거나 오류가 발생했습니다')),
                    ),
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
