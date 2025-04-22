import 'package:flutter/material.dart';
import 'package:meongjup/pages/adoption_detail.dart';

void main() {
  runApp(
    MaterialApp(
      home: MainPage(),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff5f5f5)),
      ),
    ),
  );
}
