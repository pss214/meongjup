import 'package:flutter/material.dart';
import 'package:meongjup/pages/missing_detail.dart';

class MissingPuppy extends StatefulWidget {
  final int index;
  final String ANIMAL_NO;
  final String url;
  final String NM;
  final String BREEDS;
  final String AGE;
  final double BDWGH;
  final String SEXDSTN;
  const MissingPuppy({
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
  State<MissingPuppy> createState() => _MissingPuppyState();
}

class _MissingPuppyState extends State<MissingPuppy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.94).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse().then((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => MissingDetail(
                    index: widget.index,
                    ANIMAL_NO: widget.ANIMAL_NO,
                    url: widget.url,
                    NM: widget.NM,
                    BREEDS: widget.BREEDS,
                    AGE: widget.AGE,
                    BDWGH: widget.BDWGH,
                    SEXDSTN: widget.SEXDSTN,
                  ),
            ),
          );
        });
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: Column(
          children: [
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'https://animal.seoul.go.kr/comm/getImage?srvcId=MEDIA&upperNo=4224&fileTy=ADOPTIMG&fileNo=1&thumbTy=L',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '화성시 병점동',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OOO을 찾습니다.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "이름: 초코 / 견종: 웰시코기",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF666666),
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
