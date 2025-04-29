class MissingDto {
  final String distinction;
  final String name;
  final String species;
  final String location;
  final List<String> images;
  final String subject;

  MissingDto({
    required this.distinction,
    required this.name,
    required this.species,
    required this.location,
    required this.images,
    required this.subject,
  });

  factory MissingDto.fromJson(Map<String, dynamic> json) {
    return MissingDto(
      distinction: json['distinction'],
      name: json['name'],
      species: json['species'],
      location: json['location'],
      images: List<String>.from(json['images']),
      subject: json['subject'],
    );
  }
}
