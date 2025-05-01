import 'package:flutter/material.dart';
import 'package:meongjup/pages/volunteer_detail.dart';

class VolunteerPost extends StatelessWidget {
  final String activity_period;
  final String activity_time;
  final String content;
  final String location;
  final String subject;
  final String period;
  final String personnel;
  final String target;
  const VolunteerPost({
    super.key,
    required this.activity_period,
    required this.activity_time,
    required this.content,
    required this.location,
    required this.subject,
    required this.period,
    required this.personnel,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => VolunteerDetail(
                  activity_period: activity_period,
                  activity_time: activity_time,
                  content: content,
                  location: location,
                  subject: subject,
                  period: period,
                  personnel: personnel,
                  target: target,
                ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[$location] $subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '2025-04-23',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('>', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
