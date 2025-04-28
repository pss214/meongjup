import 'package:flutter/material.dart';
import 'package:meongjup/pages/missing_detail.dart';

class MissingPuppy extends StatelessWidget {
  final int index;
  final String ANIMAL_NO;
  final String url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;
  const MissingPuppy({
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
                (context) => MissingDetail(
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
        margin: EdgeInsets.fromLTRB(10, 8, 10, 4),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(1),
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'https://animal.seoul.go.kr/comm/getImage?srvcId=MEDIA&upperNo=4224&fileTy=ADOPTIMG&fileNo=1&thumbTy=L',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '화성시 병점동',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OOO을 찾습니다.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "이름: 초코 / 견종: 웰시코기",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
