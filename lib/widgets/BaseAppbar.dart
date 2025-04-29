import 'package:flutter/material.dart';

//좌측 상단 앱바 생성
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leading: Image.asset('assets/images/icon1.png', width: 24, height: 24),
      shape: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
