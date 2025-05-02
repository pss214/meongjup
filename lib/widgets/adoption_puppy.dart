import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AdoptionPuppy extends StatefulWidget {
  final int index;
  final String animalNo;
  final String url;
  final String nm;
  final String breeds;
  final String age;
  final double bdwgh;
  final String sexdstn;
  const AdoptionPuppy({
    super.key,
    required this.index, // 인덱스
    required this.animalNo, // 동물번호
    required this.url, // 이미지 주소
    required this.nm, // 이름
    required this.breeds, // 품종
    required this.age, // 나이
    required this.bdwgh, // 몸무게
    required this.sexdstn, // 성별
  });

  @override
  State<AdoptionPuppy> createState() => _AdoptionPuppyState();
}

class _InfoLabel extends StatelessWidget {
  final String text;
  const _InfoLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF75B1FF),
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

class _AdoptionPuppyState extends State<AdoptionPuppy> {
  bool isTapped = false;

  void toggleBrightness() {
    setState(() {
      isTapped = !isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleBrightness,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity, // ✅ 가로 전체 맞춤
              height: 260,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: const Color(0xffdddddd),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        // ignore: deprecated_member_use
                        Colors.white.withOpacity(isTapped ? 0.8 : 0.0),
                        BlendMode.screen,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: 'http://${widget.url}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 260,
                      ),
                    ),
                  ),
                  if (isTapped)
                    Positioned(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.nm,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 왼쪽 라벨 (파란 배경, 흰 글씨)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                _InfoLabel(text: '견종'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  widget.breeds,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                _InfoLabel(text: '나이'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  widget.age,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                _InfoLabel(text: '성별'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  widget.sexdstn == 'M'
                                                      ? '남아'
                                                      : '여아',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                _InfoLabel(text: '성격'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '활발',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                _InfoLabel(text: '건강상태'),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '양호',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  '외부 페이지 URL로 이동합니다.',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                actionsPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10,
                                                    ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                  0xFFE0E0E0,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            '취소',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                              mode:
                                                                  LaunchMode
                                                                      .externalApplication,
                                                            );
                                                          },
                                                          style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                  0xFF75B1FF,
                                                                ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            '확인',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF75B1FF,
                                        ),
                                        minimumSize: const Size(
                                          150,
                                          40,
                                        ), // ⬅️ 이보다 작아지지 않게 보장
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '문의하기',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
