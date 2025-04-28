import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_core;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MissingPost extends StatefulWidget {
  const MissingPost({super.key});

  @override
  State<MissingPost> createState() => _MissingPostState();
}

class _MissingPostState extends State<MissingPost> {
  // 실종 글쓰기 데이터를 저장하는 컨트롤러들입니다
  final TextEditingController _titleController = TextEditingController(); // 제목
  final TextEditingController _nameController =
      TextEditingController(); // 강아지 이름
  final TextEditingController _breedController = TextEditingController(); // 견종
  final TextEditingController _featuresController =
      TextEditingController(); // 특징
  final List<String> _images = []; // 이미지 경로 리스트//firebasse db
  final List<String> _uploads = [];
  @override
  initState() {
    super.initState();
  }
  // 이 데이터들은 각각의 TextField에서 사용되고 있으며
  // 등록하기 버튼을 눌렀을 때 이 컨트롤러들의 .text 값을 통해 입력된 데이터를 가져올 수 있습니다.
  // 예: _titleController.text - 제목 데이터
  //     _nameController.text - 이름 데이터
  //     _breedController.text - 견종 데이터
  //     _featuresController.text - 특징 데이터
  //     _images - 선택된 이미지들의 경로

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1000,
    );

    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path);
      });
    }
  }

  //이미지 업로드
  Future<void> fetchImageUpload() async {
    var storageRef = FirebaseStorage.instance.ref();
    var uuid = Uuid();

    for (var element in _images) {
      String filename = uuid.v4();
      var mountainsRef = storageRef.child("$filename.jpg");
      File file = File(element);
      _uploads.add("$filename.jpg");
      try {
        await mountainsRef.putFile(file);
        // .snapshotEvents.listen((
        //   TaskSnapshot taskSnapshot,
        // ) {
        //   switch (taskSnapshot.state) {
        //     case TaskState.running:
        //       final progress =
        //           100.0 *
        //           (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text('업로드 중 : $progress'),
        //           backgroundColor: Colors.blue,
        //         ),
        //       );
        //       break;
        //     case TaskState.paused:
        //       print("Upload is paused.");
        //       break;
        //     case TaskState.canceled:
        //       print("Upload was canceled");
        //       break;
        //     case TaskState.error:
        //       // Handle unsuccessful uploads
        //       break;
        //     case TaskState.success:
        //       // Handle successful uploads on complete
        //       // ...
        //       break;
        //   }
        // });
      } on firebase_core.FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글 등록 중 오류가 발생했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //게시글 업로드
  Future<void> fetchUpload() async {
    try {
      debugPrint("전송중");
      FirebaseFirestore db = FirebaseFirestore.instance;
      await fetchImageUpload();

      final data = <String, dynamic>{
        "distinction": _breedController.text,
        "species": _featuresController.text,
        "name": _nameController.text,
        "subject": _titleController.text,
        "images": _uploads,
      };
      await db
          .collection("missing")
          .add(data)
          .then(
            (DocumentReference doc) =>
                debugPrint('DocumentSnapshot added with ID: ${doc.id}'),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시글이 업로드 되었습니다!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      debugPrint("에러 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시글 등록 중 오류가 발생했습니다. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('사진 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _validateAndSubmit() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('제목을 입력해주세요')));
      return;
    }
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('강아지 이름을 입력해주세요')));
      return;
    }
    if (_breedController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('견종을 입력해주세요')));
      return;
    }
    if (_featuresController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('특징을 입력해주세요')));
      return;
    }
    if (_images.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('최소 1장의 사진을 추가해주세요')));
      return;
    }

    // 모든 검증을 통과하면 등록 진행
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, size: 13),
                  Text('뒤로가기', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 2),
            Text(
              '  실종 글쓰기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '제목',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '글 제목 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '이름',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '강아지 이름 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '견종',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _breedController,
              decoration: InputDecoration(
                labelText: '강아지 종 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '특징',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _featuresController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '특징 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 24),
            Text(
              '사진 추가',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images
                    .map(
                      (image) => Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(image)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.remove(image);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                _images.length < 3
                    ? GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 32,
                              color: Colors.grey,
                            ),
                            Text(
                              '사진 추가',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : Container(),
              ],
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  fetchUpload();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff7373),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('등록하기', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
