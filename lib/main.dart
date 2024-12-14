import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/analyze_page.dart';
import 'package:foodgpt/pages/home_page.dart';
import 'package:foodgpt/pages/intro_page.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:IntroPage(),
      routes: {
        '/intropage':(context)=>IntroPage(),
        '/homepage':(context)=>HomePage(),
        '/analyzepage':(context)=>AnalyzePage(antecedentsList: [],confidenceValue: 0.8,liftValue: 0.9,supportValue: 0.7,),
      },
    );
  }
}

