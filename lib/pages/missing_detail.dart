import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';

class MissingDetail extends StatefulWidget {
  final int index;
  final String ANIMAL_NO;
  final String url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;
  const MissingDetail({
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
  State createState() => _MissingDetail();
}

class _MissingDetail extends State<MissingDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
      appBar: BaseAppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          IconButton(
            onPressed: () => {Navigator.of(context).pop()},
            icon: Icon(Icons.arrow_back_ios_new),
            alignment: Alignment.centerLeft,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    '이름: 초코 / 견종: 웰시코기',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff666666), height: 0.5),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    'OOO을 찾습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xffff7373),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(color: Color(0xffcccccc), height: 32),
                Text(
                  '특징',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
                  style: TextStyle(height: 1.3),
                ),
                SizedBox(height: 16),
                Image.asset(
                  'assets/images/missing_writing.png',
                  width: double.infinity,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
