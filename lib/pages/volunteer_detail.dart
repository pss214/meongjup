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
                                    await launchUrl(
                                      Uri.parse(
                                        "https://news.seoul.go.kr/env/archives/560028",
                                      ),
                                      mode: LaunchMode.externalApplication,
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
