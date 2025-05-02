import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ 추가

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leading: Image.asset('assets/images/icon1.png', width: 24, height: 24),
      shape: Border(
        bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
      ),
      actions: [
        IconButton(
          onPressed: () {
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
                                "https://news.seoul.go.kr/env/pet",
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
          icon: Icon(
            Icons.question_mark_rounded,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
