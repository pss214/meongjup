import 'package:flutter/material.dart';
import 'package:meongjup/pages/adoption_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meongjup/pages/volunteer_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: VolunteerDetail()));
}
