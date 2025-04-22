import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdoptionDetail extends StatefulWidget {
  const AdoptionDetail({super.key});
  // final String animalId;
  @override
  State createState() => _AdoptionDetail();
}

class _AdoptionDetail extends State<AdoptionDetail> {
  String src =
      'http://openapi.seoul.go.kr:8088/435a79586c62616b38344e72746d47/json/TbAdpWaitAnimalView/1/500';
  List<dynamic> data = [];
  Image? mainImg;
  @override
  void initState() {
    super.initState();
    mainImg = Image.network(
      'https://animal.seoul.go.kr/comm/getImage?srvcId=MEDIA&upperNo=4221&fileTy=ADOPTIMG&fileNo=1&thumbTy=L',
    );
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(src));
    final data = jsonDecode(response.body);
    List<dynamic> dogData = [];
    for (var i in data['TbAdpWaitAnimalView']['row']) {
      if (i['ANIMAL_NO'].toString() == "4221") {
        dogData.add(i);
        break;
      }
    }
    debugPrint(dogData[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(Icons.arrow_back_ios_new),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
              CircleAvatar(radius: 100, backgroundImage: mainImg?.image),
              Padding(padding: EdgeInsets.only(top: 20)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "희망",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "(동대문센터)",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("견종  ", style: TextStyle(color: Colors.black54)),
                        Text("믹스"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("성별  ", style: TextStyle(color: Colors.black54)),
                        Text("남"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("체중  ", style: TextStyle(color: Colors.black54)),
                        Text("2.77kg"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("나이  ", style: TextStyle(color: Colors.black54)),
                        Text("2살 2개월"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("성격  ", style: TextStyle(color: Colors.black54)),
                        Text("활발"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("건강상태  ", style: TextStyle(color: Colors.black54)),
                        Text("양호"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("기타  ", style: TextStyle(color: Colors.black54)),
                        Text("등등"),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Image.asset('assets/입양하기_배너.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
