import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/auth_or_app_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData myTheme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatNotificationService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: myTheme.colorScheme.copyWith(
              primary: const Color(0xFF474350),
              secondary: const Color(0xFFFFC857),
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                color: Color(0XFFF4F7F5),
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              titleSmall: TextStyle(
                color: Color(0XFFF4F7F5),
              ),
            ),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              refreshBackgroundColor: Color(0XFFF4F7F5),
              linearTrackColor: Color(0XFFF4F7F5),
              circularTrackColor: Color(0XFFF4F7F5),
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(fontSize: 20),
            )),
        home: const AuthOrAppPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
