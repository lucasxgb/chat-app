import 'dart:async';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Método responsável por salvar as mensagens do chat no firebase */

class ChatFirebaseService implements ChatService {
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    /* Recebe os dados sempre que a coleção for alterada visto que snapshots é um componente
    do tipo stream */
    final snapshots = store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    /* método que vai ficar escutando qualquer alteração que aconteça */

    return Stream<List<ChatMessage>>.multi((controller) {
      snapshots.listen((snapshot) {
        /* Convertendo uma stream de dados para uma lista de messages */
        List<ChatMessage> lista = snapshot.docs.map((doc) {
          return doc.data();
        }).toList();
        controller.add(lista);
      });
    });

    // Segunda opção
    // return snapshots.map((snapshot) {
    //   return snapshot.docs.map((doc) {
    //       return doc.data();
    //     }).toList();
    // });
  }

  /* Refatoração do código para quando for preciso utilizar a conversão de dado pode
  fazer da forma abaixo:  */

  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageUrl,
    );
    /*withconvert  recebe dois métodos que vão realizar a conversão*/
    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    final doc = await docRef.get();
    return doc.data()!;
  }

  /*- Receber os dados do firebase e converter para um ChatMessage, sendo usado quando
 quero pegar as informações do firebase*/
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? option,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageURL: doc['userImageURL'],
    );
  }

  /*Método que converte informações do tip Chatmessage e converte pra um MAp*/
  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageURL': msg.userImageURL,
    };
  }
}
