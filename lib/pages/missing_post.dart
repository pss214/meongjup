import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meongjup/widgets/BaseAppbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:meongjup/widgets/bottom_navigation.dart';
import 'package:uuid/uuid.dart';

class MissingPost extends StatefulWidget {
  const MissingPost({super.key});

  @override
  State<MissingPost> createState() => _MissingPostState();
}

class _MissingPostState extends State<MissingPost> {
  // 컨트롤러
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _locationinformation = TextEditingController();
  final TextEditingController _featuresController = TextEditingController();
  final List<String> _images = [];
  final List<String> _uploads = [];

  @override
  void initState() {
    super.initState();
  }

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

  // 이미지 업로드
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
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글 등록 중 오류가 발생했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 게시글 업로드
  Future<void> fetchUpload() async {
    try {
      debugPrint("전송중");
      await fetchImageUpload();
      FirebaseFirestore db = FirebaseFirestore.instance;
      final data = <String, dynamic>{
        "distinction": _breedController.text,
        "species": _featuresController.text,
        "name": _nameController.text,
        "subject": _titleController.text,
        "images": _uploads,
        "location": _locationinformation.text,
        "createdAt": DateTime.now(),
      };
      await db.collection("missing").add(data).then((doc) {
        debugPrint('DocumentSnapshot added with ID: ${doc.id}');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시글이 업로드 되었습니다!'),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.pop(context);
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

  // 스낵바 헬퍼
  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _empty(String text) => text.trim().isEmpty;

  bool _isKoreanOnly(String text) {
    final trimmed = text.trim();
    return RegExp(r'^[가-힣\s]+$').hasMatch(trimmed) &&
        RegExp(r'[가-힣]').hasMatch(trimmed);
  }

  // 검증 후 업로드
  bool _validateAndSubmit() {
    String errorMsg(String field) => '$field(은/는) 한글만 입력해주세요';
    String emptyMsg(String field) => '$field(을/를) 입력해주세요';

    // 제목
    if (_empty(_titleController.text)) {
      _snack(emptyMsg('제목'));
      return false;
    }
    if (!_isKoreanOnly(_titleController.text)) {
      _snack(errorMsg('제목'));
      return false;
    }

    // 이름
    if (_empty(_nameController.text)) {
      _snack(emptyMsg('강아지 이름'));
      return false;
    }
    if (!_isKoreanOnly(_nameController.text)) {
      _snack(errorMsg('이름'));
      return false;
    }

    // 견종
    if (_empty(_breedController.text)) {
      _snack(emptyMsg('견종'));
      return false;
    }
    if (!_isKoreanOnly(_breedController.text)) {
      _snack(errorMsg('견종'));
      return false;
    }

    // 위치
    if (_empty(_locationinformation.text)) {
      _snack(emptyMsg('위치'));
      return false;
    }
    if (!_isKoreanOnly(_locationinformation.text)) {
      _snack(errorMsg('위치'));
      return false;
    }

    // 특징
    if (_empty(_featuresController.text)) {
      _snack(emptyMsg('특징'));
      return false;
    }
    if (!_isKoreanOnly(_featuresController.text)) {
      _snack(errorMsg('특징'));
      return false;
    }

    // 사진
    if (_images.isEmpty) {
      _snack('최소 1장의 사진을 추가해주세요');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      bottomNavigationBar: BottomNavigation(selectedIndex: 2),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, size: 13),
                  Text('뒤로가기', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '실종 글쓰기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildLabelText('제목'),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '글 제목 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            _buildLabelText('이름'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '강아지 이름 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            _buildLabelText('견종'),
            TextField(
              controller: _breedController,
              decoration: InputDecoration(
                labelText: '강아지 종 입력',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            _buildLabelText('위치'),
            TextField(
              controller: _locationinformation,
              decoration: InputDecoration(
                labelText: 'OO시 OO구',
                border: UnderlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
            SizedBox(height: 8),
            _buildLabelText('특징'),
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
            _buildLabelText('사진 추가'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images.map((image) => _buildImageTile(image)).toList(),
                if (_images.length < 3) _buildAddPhotoBox(),
              ],
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (!_validateAndSubmit()) return;
                  fetchUpload();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFff7373),
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

  Widget _buildLabelText(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildImageTile(String image) => Stack(
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
          onTap: () => setState(() => _images.remove(image)),
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 20, color: Colors.grey),
          ),
        ),
      ),
    ],
  );

  Widget _buildAddPhotoBox() => GestureDetector(
    onTap: _showImageSourceDialog,
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
          Text('사진 추가', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    ),
  );

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('사진 선택'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('갤러리에서 선택'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('취소'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
