import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/volunteerActivityDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerDetail extends StatelessWidget {
  final String activity_period;
  final String activity_time;
  final String content;
  final String location;
  final String subject;
  final String period;
  final String personnel;
  final String target;
  const VolunteerDetail({
    super.key,
    required this.activity_period,
    required this.activity_time,
    required this.content,
    required this.location,
    required this.subject,
    required this.period,
    required this.personnel,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              constraints: BoxConstraints(minHeight: 700),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => {Navigator.of(context).pop()},
                        icon: Icon(Icons.arrow_back_ios_new),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            subject,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(color: Color(0xffcccccc), height: 40),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              VolunteerActivityDetails(
                                title: "활동기간",
                                content: activity_period,
                              ),
                              VolunteerActivityDetails(
                                title: "활동시간",
                                content: activity_time,
                              ),
                              SizedBox(height: 10),
                              VolunteerActivityDetails(
                                title: "모집대상",
                                content: target,
                              ),
                              SizedBox(height: 10),
                              VolunteerActivityDetails(
                                title: "모집기간",
                                content: period,
                              ),
                              SizedBox(height: 10),
                              VolunteerActivityDetails(
                                title: "모집인원",
                                content: personnel,
                              ),
                              VolunteerActivityDetails(
                                title: "활동내용",
                                content: content,
                              ),
                              SizedBox(height: 40),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff75B1FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.fromLTRB(36, 12, 36, 12),
                                child: GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          '외부 페이지 URL로 이동합니다.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        actions: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: const Color(0xFFE0E0E0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    '취소',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await launchUrl(
                                                      Uri.parse(
                                                        "https://news.seoul.go.kr/env/archives/560028",
                                                      ),
                                                      mode: LaunchMode.externalApplication,
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: const Color(0xFF75B1FF),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    '확인',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "지원하기",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

// https://news.seoul.go.kr/env/archives/560028
