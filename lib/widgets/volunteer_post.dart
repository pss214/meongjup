import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meongjup/pages/volunteer_detail.dart';

class VolunteerPost extends StatelessWidget {
  final String activityPeriod;
  final String activityTime;
  final String content;
  final String location;
  final String subject;
  final String period;
  final String personnel;
  final String target;
  const VolunteerPost({
    super.key,
    required this.activityPeriod,
    required this.activityTime,
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
                  activityPeriod: activityPeriod,
                  activityTime: activityTime,
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
      child: SizedBox(
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '2025-04-23',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text('>', style: TextStyle(fontSize: 20.sp)),
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
