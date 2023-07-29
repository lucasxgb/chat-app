import 'package:chat/pages/loading_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData myTheme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: myTheme.colorScheme.copyWith(
          primary: Color(0xFF474350),
          secondary: Color(0xFFFFC857),
        ),
        textTheme: const TextTheme(
            titleSmall: TextStyle(
          color: Color(0XFFF4F7F5),
        )),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          refreshBackgroundColor: Color(0XFFF4F7F5),
          linearTrackColor: Color(0XFFF4F7F5),
          circularTrackColor: Color(0XFFF4F7F5),
        ),
      ),
      home: const LoadingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
