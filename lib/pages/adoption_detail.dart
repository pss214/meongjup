import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';

class AdoptionDetail extends StatefulWidget {
  final int index;
  final String ANIMAL_NO;
  final String url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;
  const AdoptionDetail({
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
  State createState() => _AdoptionDetail();
}

class _AdoptionDetail extends State<AdoptionDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(selectedIndex: 0),
      appBar: BaseAppBar(),
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
                    onPressed: () => {Navigator.of(context).pop()},
                    icon: Icon(Icons.arrow_back_ios_new),
                    alignment: Alignment.centerLeft,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage('http://${widget.url}'),
              ),
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
