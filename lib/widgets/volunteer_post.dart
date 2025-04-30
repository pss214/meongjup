import 'package:flutter/material.dart';

class VolunteerPost extends StatelessWidget {
  const VolunteerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[공지] 경산 길고양이 쉼터 자원봉사자모집',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '2025-04-23',
                    style: TextStyle(fontSize: 12, color: Color(0xff666666)),
                  ),
                ],
              ),
              Text('>', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
        SizedBox(height: 6),
      ],
    );
  }
}
