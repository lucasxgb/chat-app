import 'dart:io';

import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool belongsToCurrentUser;
  static const _defaultImage = 'assets/images/avatar.png';

  const MessageBubble({
    super.key,
    required this.message,
    required this.belongsToCurrentUser,
  });

  Widget _showUserImage(String imageURL) {
    ImageProvider? provider;
    final uri = Uri.parse(imageURL);

    if (uri.path.contains(_defaultImage)) {
      provider = AssetImage(_defaultImage);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 180,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              decoration: BoxDecoration(
                color: belongsToCurrentUser
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: belongsToCurrentUser
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: belongsToCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: belongsToCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: belongsToCurrentUser
                          ? const Color(0xFF1C1C1C)
                          : const Color(0XFFF4F7F5),
                    ),
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: belongsToCurrentUser
                          ? const Color(0xFF1C1C1C)
                          : const Color(0XFFF4F7F5),
                    ),
                    textAlign:
                        belongsToCurrentUser ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: 0,
            left: belongsToCurrentUser ? null : 165,
            right: belongsToCurrentUser ? 165 : null,
            child: _showUserImage(message.userImageURL))
      ],
    );
  }
}
