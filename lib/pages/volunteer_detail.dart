import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:meongjup/widgets/volunteerActivityDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerDetail extends StatelessWidget {
  const VolunteerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 3),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  "[공지] 경산 길고양이 쉼터 자원봉사자 모집",
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(color: Color(0xffcccccc), height: 40),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    VolunteerActivityDetails(
                      title: "활동내용",
                      content: "입양 대기중인 유기동물과 인근 공원 등 야외 산책 및 놀이활동",
                    ),
                    SizedBox(height: 10),
                    VolunteerActivityDetails(
                      title: "활동시간",
                      content: "오전반 10:00 ~ 12:00",
                    ),
                    SizedBox(height: 10),
                    VolunteerActivityDetails(
                      title: "모집대상",
                      content: "3개월 동안 5회 이상 지속적이고 정기적인 봉사가능한 성인",
                    ),
                    SizedBox(height: 10),
                    VolunteerActivityDetails(
                      title: "모집기간",
                      content: "2025.01.15~02.28",
                    ),
                    SizedBox(height: 10),
                    VolunteerActivityDetails(
                      title: "모집인원",
                      content: "1일 오전반 4명씩(1365 자원봉사 신청란에서 실시간 조회 가능)",
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff75B1FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.fromLTRB(36, 12, 36, 12),
                      child: GestureDetector(
                        onTap:
                            () => {
                              launchUrl(
                                Uri.parse(
                                  "https://news.seoul.go.kr/env/archives/560028",
                                ),
                                mode: LaunchMode.externalApplication,
                              ),
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
      ),
    );
  }
}

// https://news.seoul.go.kr/env/archives/560028
