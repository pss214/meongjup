import 'package:flutter/material.dart';
import 'package:meongjup/pages/adoption_detail.dart';

class AdoptionPuppy extends StatelessWidget {
  final int index;
  final String ANIMAL_NO;
  final String url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;
  const AdoptionPuppy({
    super.key,
    required this.index,
    required this.ANIMAL_NO,
    required this.url,
    required this.NM,
    required this.BREEDS,
    required this.AGE,
    required this.BDWGH,
    required this.SEXDSTN,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => AdoptionDetail(
                  index: index,
                  ANIMAL_NO: ANIMAL_NO,
                  url: url,
                  NM: NM,
                  BREEDS: BREEDS,
                  AGE: AGE,
                  BDWGH: BDWGH,
                  SEXDSTN: SEXDSTN,
                ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Column(
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
                    image: DecorationImage(
                      image: NetworkImage('http://$url'), // 여기가 핵심!
                      fit: BoxFit.cover, // 꽉 채우고 싶을 때,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      BREEDS.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '나이 ${AGE}',
                      style: TextStyle(
                        color: Color(0xff505050),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '성별 ${(SEXDSTN == 'M') ? "남" : "여"}',
                      style: TextStyle(
                        color: Color(0xff505050),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '체중 ${BDWGH}',
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
        ),
      ),
    );
  }
}
