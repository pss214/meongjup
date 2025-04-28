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
  void _showInquiryModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.asset(
            'assets/images/입양문의_모달창.png',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 0),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
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
              SizedBox(height: 20),
              Text(
                widget.NM,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('성별', style: TextStyle(color: Colors.grey)),
                      Text(widget.SEXDSTN),
                    ],
                  ),
                  Column(
                    children: [
                      Text('체중', style: TextStyle(color: Colors.grey)),
                      Text('${widget.BDWGH}kg'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('나이', style: TextStyle(color: Colors.grey)),
                      Text(widget.AGE),
                    ],
                  ),
                  Column(
                    children: [
                      Text('성격', style: TextStyle(color: Colors.grey)),
                      Text('활발'),
                    ],
                  ),
                  Column(
                    children: [
                      Text('건강', style: TextStyle(color: Colors.grey)),
                      Text('양호'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF75B1FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('     센터:    ',
                              style: TextStyle(
                                color: Colors.white
                              )
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('동대문 동물보호센터'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF75B1FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(' 센터 주소:',
                              style: TextStyle(
                                color: Colors.white,
                              )
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('서울특별시 동대문구 장안동 329-1'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF75B1FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(' 전화번호: ',
                              style: TextStyle(
                                color: Colors.white,
                              )
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('02-2127-4090'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _showInquiryModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF75B1FF),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8), // vertical 패딩을 15에서 10으로 줄임
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '문의하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.grey[300]),
              SizedBox(height: 20),
              Image.asset('assets/images/입양하기_배너.png'),
            ],
          ),
        ),
      ),
    );
  }
}
