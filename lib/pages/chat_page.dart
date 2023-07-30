import 'package:chat/core/services/auth/auth_mock_services.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('É o chat né vida?'),
          ),
          TextButton(
            onPressed: () {
              AuthMockService().logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
