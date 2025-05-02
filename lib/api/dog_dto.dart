class DogDtoList {
  late final List<DogDto> dogs;

  DogDtoList({required this.dogs});

  factory DogDtoList.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['row'] as List;

    List<DogDto> postList =
        list
            .where((i) => i['SPCS'] == "DOG" && i['ADP_STTUS'] == 'N')
            .map((i) => DogDto.fromJson(i))
            .toList();
    return DogDtoList(dogs: postList);
  }
  static Future<List<DogDto>> getDogDto(int page) {
    return Future.delayed(const Duration(seconds: 0), () => []);
  }
}

class DogDto {
  final String animalNo;
  final String? url;
  final String nm;
  final String breeds;
  final String age;
  final double bdwgh;
  final String sexdstn;

  DogDto({
    required this.animalNo,
    required this.url,
    required this.nm,
    required this.breeds,
    required this.age,
    required this.bdwgh,
    required this.sexdstn,
  });
  factory DogDto.fromJson(Map<String, dynamic> json) {
    String? url;
    String nm = json['NM'];
    String age = json['AGE'];
    String breeds = json['BREEDS'];
    double bdwgh = json['BDWGH'];
    String sexdstn = json['SEXDSTN'];
    String animalNo = json['ANIMAL_NO'];

    return DogDto(
      animalNo: animalNo,
      url: url,
      nm: nm,
      breeds: breeds,
      age: age,
      bdwgh: bdwgh,
      sexdstn: sexdstn,
    );
  }
}
