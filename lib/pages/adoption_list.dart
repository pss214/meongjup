import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meongjup/api/dog_dto.dart';
import 'package:meongjup/widgets/base_appbar.dart';
import 'package:meongjup/widgets/adoption_puppy.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'dart:math';

class AdoptionList extends StatefulWidget {
  const AdoptionList({super.key});
  @override
  State createState() => _AdoptionList();
}

class _AdoptionList extends State<AdoptionList> {
  final ScrollController _scrollController = ScrollController();
  DogDtoList? dogdata;
  late final PagingController<int, DogDto> _pagingController = PagingController(
    getNextPageKey: _getNextPageKey,
    fetchPage: (pageKey) async => fetchData(pageKey),
  );
  Map<String, List<String>> imageList = {};
  List<String> breedsList = [];
  List<Uint8List?>? thumbnails;
  Map<String, bool> imageOpacityMap = {};
  String selectedBreed = '전체';

  // 감성적인 문구 리스트
  List<String> emotionalQuotes = [
    "누군가의 사랑을 기다리는 이 작은 영혼에게, 당신의 따뜻한 손길이 필요해요.",
    "입양은 단순한 선택이 아니라, 한 생명을 위한 사랑의 시작이에요.",
    "당신의 마음을 열고, 이 작은 강아지가 찾아온다면 행복은 더 커질 거예요.",
    "입양은 사랑을 나누는 가장 아름다운 방법이에요. 이제 이 강아지가 당신의 가족이 될 차례입니다.",
    "사랑을 나누고 싶다면, 이 작은 강아지가 가장 먼저 필요한 사람입니다.",
    "이 강아지는 이제 더 이상 혼자가 아니에요. 당신의 손길을 기다리고 있어요.",
    "세상의 모든 강아지들은 입양을 통해 새로운 희망을 만듭니다. 그 희망이 되어주세요.",
    "귀여운 눈망울을 한 번만 보면, 당신도 이 강아지를 놓칠 수 없을 거예요.",
    "강아지 한 마리의 작은 발걸음은, 큰 행복의 시작이 될 수 있어요.",
    "당신의 사랑을 받는 강아지, 그 누구보다 행복할 거예요.",
    "이 작은 생명에게 집을 열어주세요. 강아지들은 항상 마음의 문을 열어줍니다.",
    "입양은 새로운 시작이에요. 이 강아지와 함께라면 매일이 특별한 날이 될 거예요.",
    "세상에서 가장 큰 행복은 작은 발소리 속에 숨겨져 있어요.",
    "이 작은 존재에게 사랑을 주면, 그 사랑이 당신에게 돌아올 거예요.",
    "지금 이 순간, 누군가를 기다리고 있어요. 바로 당신을!",
    "강아지와 함께하는 삶은, 그 자체로 꿈만 같아요.",
    "이 강아지는 사랑과 보호를 받을 자격이 있어요. 그 사랑을 줄 사람은 바로 당신입니다.",
    "어떤 날이든, 이 강아지와 함께라면 모든 것이 완벽해질 거예요.",
    "당신의 품에 안길 강아지가 기다리고 있어요. 그 작은 사랑이 큰 행복을 가져올 거예요.",
    "가족을 더 넓히고 싶다면, 이 강아지에게 따뜻한 집을 만들어주세요.",
    "강아지의 눈빛 속에 담긴 사랑을 받아들이고, 새로운 가족을 만들어보세요.",
    "이 작은 생명도 당신만의 사랑을 받을 자격이 있어요.",
    "모든 강아지는 사랑을 기다립니다. 이제 그 사랑을 주는 사람이 되어보세요.",
    "강아지 입양은 그저 '새로운 시작'이에요. 시작하는 순간부터 함께할 모든 순간들이 기적이에요.",
    "이 강아지의 첫 번째 발걸음은 당신의 손을 잡고 떠날 준비가 되어 있어요.",
    "세상에 고백할 사랑은 많지만, 강아지와 나누는 사랑은 특별합니다.",
    "당신의 마음을 열어, 이 강아지에게 사랑을 주면 그 사랑이 당신을 더 행복하게 만들어줄 거예요.",
    "입양은 사랑을 주는 일, 그 사랑이 이 강아지의 인생을 바꿀 수 있어요.",
    "강아지의 작은 발걸음이 큰 사랑의 시작이 될 거예요.",
    "귀여운 강아지에게 사랑을 주면, 세상에서 가장 따뜻한 가족이 될 거예요.",
    "이 작은 존재가 더 이상 외로움 없이, 당신의 품 안에서 행복하게 살아가기를 꿈꾸고 있어요.",
    "사랑을 주고 싶은 강아지가 기다리고 있어요. 그 사랑을 주는 사람은 바로 당신입니다.",
    "강아지와 함께라면, 매일이 더 즐겁고 행복해질 거예요.",
    "이 강아지의 마음을 열어주면, 그 사랑이 당신에게 돌아올 거예요.",
    "강아지는 사랑을 전하는 메신저입니다. 그 메시지를 당신에게 전달하고 싶어요.",
    "입양은 작은 기적을 만드는 일입니다. 당신도 그 기적의 일부가 될 수 있어요.",
    "강아지에게 따뜻한 집을 열어주는 것은, 사랑을 나누는 가장 아름다운 일이에요.",
    "이 강아지에게 필요한 것은 사랑입니다. 그 사랑을 줄 수 있는 사람은 바로 당신이에요.",
    "당신의 집에 이 작은 존재가 온다면, 집은 더 이상 비어 있지 않을 거예요.",
    "이 작은 강아지가 당신에게 줄 수 있는 것은 무한한 사랑이에요.",
    "강아지와 함께하는 순간은 어떤 순간보다 소중할 거예요.",
    "이 강아지가 당신의 품 안에서 행복하게 살아갈 수 있도록 도와주세요.",
    "이 강아지의 인생을 바꿀 수 있는 사람은 바로 당신입니다.",
    "당신이 주는 사랑으로 이 강아지가 매일 행복할 거예요.",
    "세상에서 가장 귀한 선물은 강아지와 함께하는 시간입니다.",
    "당신의 사랑을 기다리는 강아지가 있습니다. 이제 그 사랑을 나눠주세요.",
    "강아지에게 따뜻한 집을 주면, 그 집은 사랑으로 가득 찰 거예요.",
    "이 강아지와 함께라면, 삶의 모든 순간이 특별해질 거예요.",
    "강아지는 우리에게 진정한 사랑을 보여주는 존재입니다. 그 사랑을 주고받을 준비가 되셨나요?",
    "입양은 강아지에게 새로운 인생을 주는 것, 그리고 그 인생이 당신의 삶을 더욱 아름답게 만들 거예요.",
  ];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  // 랜덤으로 감성적인 문구를 선택하는 함수
  String getRandomQuote() {
    final random = Random();
    return emotionalQuotes[random.nextInt(emotionalQuotes.length)];
  }

  int? _getNextPageKey(PagingState<int, DogDto> state) {
    try {
      final keys = state.keys;
      if (keys == null) return 1;
      if (dogdata == null) {
        if (keys.last >= 15) return null;
      } else {
        if (keys.last < dogdata!.dogs.length) {
          return null;
        }
      }
      debugPrint(keys.last.toString());
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

      // ✅ 필터 적용
      List<DogDto> filteredDogs =
          selectedBreed == '전체'
              ? dogdata!.dogs
              : dogdata!.dogs
                  .where((dog) => dog.breeds == selectedBreed)
                  .toList();

      final startIndex = (page - 1) * 15;
      final endIndex = startIndex + 15;
      if (startIndex >= filteredDogs.length) {
        return [];
      }
      return filteredDogs.sublist(
        startIndex,
        endIndex > filteredDogs.length ? filteredDogs.length : endIndex,
      );
    } catch (e) {
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
          breedsList = [
            '전체',
            ...{
              for (var dog in dogdata!.dogs) dog.breeds,
            }.toSet(), // 품종 고정화 + 복잡 제거
          ];
        });
        await fetchImage();
      } else {
        throw Exception('Failed to fetch data');
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

        for (var element in dogdata!.dogs) {
          imageList[element.animalNo] = [];
          imageOpacityMap[element.animalNo] = false;
          for (var i = 0; i < data.length; i++) {
            if (element.animalNo == data[i]['ANIMAL_NO']) {
              if (data[i]['PHOTO_KND'] == 'IMG') {
                imageList[data[i]['ANIMAL_NO']]?.add(data[i]['PHOTO_URL']);
                break;
              }
            }
          }
        }
        _pagingController.refresh();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
      body: Column(
        children: [
          SizedBox(height: 4),
          Container(
            height: 60,
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    breedsList
                        .map(
                          (breed) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedBreed = breed;
                                  _pagingController.refresh();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selectedBreed == breed
                                          ? Colors.black
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  breed,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        selectedBreed == breed
                                            ? Colors.white
                                            : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await fetch();
              },
              child: PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) {
                  return PagedListView<int, DogDto>(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder:
                          (context, item, index) => Column(
                            children: [
                              GestureDetector(
                                child: SizedBox(
                                  height: 270,
                                  child: Opacity(
                                    opacity:
                                        imageOpacityMap[item.animalNo] == true
                                            ? 0.2
                                            : 1.0,
                                    child: AdoptionPuppy(
                                      index: index,
                                      animalNo: item.animalNo,
                                      url: imageList[item.animalNo]?[0] ?? '',
                                      nm: item.nm,
                                      breeds: item.breeds,
                                      age: item.age,
                                      bdwgh: item.bdwgh,
                                      sexdstn: item.sexdstn,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(15),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getRandomQuote(), // 랜덤 문구가 출력됩니다.
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
