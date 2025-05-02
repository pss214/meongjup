class VolunteerDto {
  final String activityPeriod;
  final String activityTime;
  final String content;
  final String location;
  final String subject;
  final String period;
  final String personnel;
  final String target;

  VolunteerDto({
    required this.activityPeriod,
    required this.activityTime,
    required this.content,
    required this.location,
    required this.subject,
    required this.period,
    required this.personnel,
    required this.target,
  });

  factory VolunteerDto.fromJson(Map<String, dynamic> json) {
    return VolunteerDto(
      activityPeriod: json['activity_period'],
      activityTime: json['activity_time'],
      content: json['content'],
      location: json['location'],
      subject: json['subject'],
      period: json['period'],
      personnel: json['personnel'],
      target: json['target'],
    );
  }
}
