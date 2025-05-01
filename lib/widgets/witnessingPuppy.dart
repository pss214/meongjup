import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/pages/missing_detail.dart';

class WitnessingPuppy extends StatefulWidget {
  final String distinction;
  final String species;
  final String name;
  final String subject;
  final List<String> images;
  final String location;
  const WitnessingPuppy({
    super.key,
    required this.distinction,
    required this.species,
    required this.name,
    required this.subject,
    required this.images,
    required this.location,
  });

  @override
  State<WitnessingPuppy> createState() => _WitnessingPuppyState();
}

class _WitnessingPuppyState extends State<WitnessingPuppy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Uint8List? thumbnail;

  Future<void> getImage() async {
    if (thumbnail != null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child(widget.images[0]);

    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? thumbnail = await islandRef.getData(oneMegabyte);
      if (!mounted) return;
      setState(() {
        this.thumbnail = thumbnail;
      });
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.94).animate(_controller);
    getImage();
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
                    distinction: widget.distinction,
                    species: widget.species,
                    name: widget.name,
                    subject: widget.subject,
                    images: widget.images,
                    location: widget.location,
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
                    child:
                        thumbnail != null
                            ? Image(
                              image: MemoryImage(thumbnail!),
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xffeeeeee),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                      child: Text(
                        widget.location,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
                    widget.subject,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "이름: ${widget.name} / 견종: ${widget.distinction}",
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
