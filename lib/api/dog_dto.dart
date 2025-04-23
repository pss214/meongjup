class DogDtoList {
  late final List<DogDto> dogs;

  DogDtoList({required this.dogs});

  factory DogDtoList.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['row'] as List;

    List<DogDto> postList =
        list
            .where((i) => i['SPCS'] == "DOG")
            .map((i) => DogDto.fromJson(i))
            .toList();
    return DogDtoList(dogs: postList);
  }
  static Future<List<DogDto>> getDogDto(int page) {
    return Future.delayed(const Duration(seconds: 0), () => []);
  }
}

class DogDto {
  final String ANIMAL_NO;
  final String? url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;

  DogDto({
    required this.ANIMAL_NO,
    required this.url,
    required this.NM,
    required this.BREEDS,
    required this.AGE,
    required this.BDWGH,
    required this.SEXDSTN,
  });
  factory DogDto.fromJson(Map<String, dynamic> json) {
    String? url = null;
    String NM = json['NM'];
    String AGE = json['AGE'];
    String BREEDS = json['BREEDS'];
    double BDWGH = json['BDWGH'];
    String SEXDSTN = json['SEXDSTN'];
    String ANIMAL_NO = json['ANIMAL_NO'];

    return DogDto(
      ANIMAL_NO: ANIMAL_NO,
      url: url,
      NM: NM,
      BREEDS: BREEDS,
      AGE: AGE,
      BDWGH: BDWGH,
      SEXDSTN: SEXDSTN,
    );
  }
}
