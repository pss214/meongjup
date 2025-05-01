class VolunteerDto {
  final String activity_period;
  final String activity_time;
  final String content;
  final String location;
  final String subject;
  final String period;
  final String personnel;
  final String target;

  VolunteerDto({
    required this.activity_period,
    required this.activity_time,
    required this.content,
    required this.location,
    required this.subject,
    required this.period,
    required this.personnel,
    required this.target,
  });

  factory VolunteerDto.fromJson(Map<String, dynamic> json) {
    return VolunteerDto(
      activity_period: json['activity_period'],
      activity_time: json['activity_time'],
      content: json['content'],
      location: json['location'],
      subject: json['subject'],
      period: json['period'],
      personnel: json['personnel'],
      target: json['target'],
    );
  }
}
