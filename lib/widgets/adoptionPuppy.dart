import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AdoptionPuppy extends StatefulWidget {
  final int index;
  final String ANIMAL_NO;
  final String url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;
  const AdoptionPuppy({
    super.key,
    required this.index, // 인덱스
    required this.ANIMAL_NO, // 동물번호
    required this.url, // 이미지 주소
    required this.NM, // 이름
    required this.BREEDS, // 품종
    required this.AGE, // 나이
    required this.BDWGH, // 몸무게
    required this.SEXDSTN, // 성별
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

  void _showInquiryModal() async {
    final url = Uri.parse(
      'https://news.seoul.go.kr/env/pet',
    ); // ✅ 여기에 이동할 URL 입력
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                                      widget.NM,
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
                                                  widget.BREEDS,
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
                                                  widget.AGE,
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
                                                  widget.SEXDSTN == 'M'
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
                                      onPressed: _showInquiryModal,
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


// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:meongjup/pages/adoption_detail.dart';

// class AdoptionPuppy extends StatelessWidget {
//   final int index;
//   final String ANIMAL_NO;
//   final String url;
//   final String NM;
//   final String BREEDS;
//   final String AGE;
//   final double BDWGH;
//   final String SEXDSTN;
//   const AdoptionPuppy({
//     super.key,
//     required this.index,
//     required this.ANIMAL_NO,
//     required this.url,
//     required this.NM,
//     required this.BREEDS,
//     required this.AGE,
//     required this.BDWGH,
//     required this.SEXDSTN,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
      
//       // onTap: () {
//       //   Navigator.of(context).push(
//       //     MaterialPageRoute(
//       //       builder:
//       //           (context) => AdoptionDetail(
//       //             index: index,
//       //             ANIMAL_NO: ANIMAL_NO,
//       //             url: url,
//       //             NM: NM,
//       //             BREEDS: BREEDS,
//       //             AGE: AGE,
//       //             BDWGH: BDWGH,
//       //             SEXDSTN: SEXDSTN,
//       //           ),
//       //     ),
//       //   );
//       // },
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 SizedBox(width: 14),
//                 Expanded(
//                   child: Container(
//                     height: 250,
//                     clipBehavior: Clip.hardEdge,
//                     decoration: BoxDecoration(
//                       color: Color(0xffdddddd),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: CachedNetworkImage(
//                       imageUrl: 'http://$url',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 14),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
