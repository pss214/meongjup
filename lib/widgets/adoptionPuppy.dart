import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdoptionPuppy extends StatelessWidget {
  const AdoptionPuppy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 8),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xffdddddd),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '견종',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '나이',
                  style: TextStyle(
                    color: Color(0xff505050),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '성별',
                  style: TextStyle(
                    color: Color(0xff505050),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '체중',
                  style: TextStyle(
                    color: Color(0xff505050),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
