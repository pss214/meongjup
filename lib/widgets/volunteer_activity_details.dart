import 'package:flutter/material.dart';

class VolunteerActivityDetails extends StatelessWidget {
  final String title;
  final String content;

  const VolunteerActivityDetails({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF8FBFF),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff75B1FF),
            ),
          ),
        ),
        SizedBox(width: 12), // 텍스트 사이 간격
        Expanded(
          // 중요: Text가 Row 내에서 줄바꿈하려면 필요
          child: Text(
            content,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
