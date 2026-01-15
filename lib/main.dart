import 'package:flutter/material.dart';
import 'screens/diary_calendar_page.dart';
import 'package:intl/intl.dart';

void main(){
  Intl.defaultLocale = 'en_US';
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CI3 JWT Demo',
      debugShowCheckedModeBanner: false,
       home: DiaryCalendarPage(),
    );
  }
}
