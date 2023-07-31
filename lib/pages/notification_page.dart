import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatNotificationService>(context);
    final items = chatService.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas notificações'),
      ),
      body: ListView.builder(
        itemCount: chatService.itemsCount,
        itemBuilder: (ctx, index) => Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Theme.of(context).colorScheme.primary,
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
          ),
          onDismissed: (_) {
            Provider.of<ChatNotificationService>(context, listen: false)
                .remove(index);
          },
          child: ListTile(
            title: Text(items[index].title),
            subtitle: Text(items[index].body),
            onTap: () => chatService.remove(index),
          ),
        ),
      ),
    );
  }
}
