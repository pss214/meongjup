import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meongjup/api/dog_dto.dart';
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
  @override
  void initState() {
    super.initState();
  }

  int? _getNextPageKey(PagingState<int, DogDto> state) {
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
  }

  Future<List<DogDto>> fetchData(int page) async {
    if (dogdata == null) {
      await fetch();
    }
    return dogdata!.dogs.sublist(page);
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
      }
    } catch (e) {
      throw Exception('Failed to fetch data');
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
          for (var i = 0; i < data.length; i++) {
            imageList[element.ANIMAL_NO] = [];
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
      throw Exception('Failed to fetch data : $e');
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xffaaaaaa),
                                radius: 40,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '견종',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
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
              onRefresh: () async => _pagingController.refresh(),
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
                            url: imageList[item.ANIMAL_NO]![0].toString(),
                            NM: item.NM,
                            BREEDS: item.BREEDS,
                            AGE: item.AGE,
                            BDWGH: item.BDWGH,
                            SEXDSTN: item.SEXDSTN,
                          ),
                      noItemsFoundIndicatorBuilder:
                          (_) => Center(child: Text('데이터가 없습니다')),
                      firstPageErrorIndicatorBuilder:
                          (_) => Center(child: Text('오류가 발생했습니다')),
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
