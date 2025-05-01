import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/pages/adoption_list.dart';

class AdoptionPuppyAtMain extends StatelessWidget {
  final int? index;
  final String? ANIMAL_NO;
  final String? url;
  final String? NM;
  final String? BREEDS;
  final String? AGE;
  final double? BDWGH;
  final String? SEXDSTN;

  const AdoptionPuppyAtMain({
    super.key,
    this.index,
    this.ANIMAL_NO,
    this.url,
    this.NM,
    this.BREEDS,
    this.AGE,
    this.BDWGH,
    this.SEXDSTN,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdoptionList()),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Container(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    url != null
                        ? CachedNetworkImage(
                          imageUrl: "https://$url",
                          fit: BoxFit.cover,
                        )
                        : Container(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '믹스',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '나이 3(세) 11(개월)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff333333),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '성별 여',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff333333),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '체중 4.87(kg)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff333333),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '동물학대로 버려진 아이에게 도움의 손길을 주세요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
