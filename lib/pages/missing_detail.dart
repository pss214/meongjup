import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';

class MissingDetail extends StatefulWidget {
  final String distinction;
  final String species;
  final String name;
  final String subject;
  final List<String> images;
  final String location;
  const MissingDetail({
    super.key,
    required this.distinction,
    required this.species,
    required this.name,
    required this.subject,
    required this.images,
    required this.location,
  });

  @override
  State createState() => _MissingDetail();
}

class _MissingDetail extends State<MissingDetail> {
  List<Uint8List> images = [];

  Future<void> getImage() async {
    final storageRef = FirebaseStorage.instance.ref();
    List<Uint8List> newImages = [];
    for (var image in widget.images) {
      final islandRef = storageRef.child(image);
      try {
        const oneMegabyte = 1024 * 1024;
        final Uint8List? image = await islandRef.getData(oneMegabyte);
        if (image != null) {
          newImages.add(image);
        }
      } on FirebaseException catch (e) {
        // Handle any errors.
      }
    }
    setState(() {
      images = newImages;
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
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
                    '이름: ${widget.name} / 견종: ${widget.distinction}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff666666), height: 0.5),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.subject,
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
                Text(widget.species, style: TextStyle(height: 1.3)),
                SizedBox(height: 16),
                if (images.isNotEmpty) ...[
                  ...images
                      .map(
                        (image) => Column(
                          children: [
                            Image.memory(
                              image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      )
                      .toList(),
                ] else
                  Container(
                    width: double.infinity,
                    height: 120,
                    color: Color(0xffeeeeee),
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
