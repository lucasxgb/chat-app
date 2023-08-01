import 'dart:async';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Método responsável por salvar as mensagens do chat no firebase */

class ChatFirebaseService implements ChatService {
  Stream<List<ChatMessage>> messagesStream() {
    return Stream<List<ChatMessage>>.empty();
  }

  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;
    /* Transformando uma mensagem do tipo ChatMessage em um 
    Map<String, dynamic> */
    final docRef = await store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageURL': user.imageUrl,
    });

    /* Com a referência de um documento, eu consigo pegar um snapshot, que seria uma 
    foto daquele documento (DocumentSnapshot) */
    final doc = await docRef.get();
    final data = doc.data()!;

    /* Convertendo um Map<String,dynamic> para um ChatMessage */
    return ChatMessage(
      id: doc.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
      userId: data['userId'],
      userName: data['userName'],
      userImageURL: data['userImageURL'],
    );

    /* Refatoração do código para quando for preciso utilizar a conversão de dado pode
  fazer da forma abaixo:  */

    /*Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.Now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    )
    withconvert  recebe dois métodos que vão realizar a conversão
    final docRefII = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    final doc = await docRef.get();
    return doc.data!

  }

 - Receber os dados do firebase e converter para um ChatMessage, sendo usado quando
 quero pegar as informações do firebase
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


  Método que converte informações do tip Chatmessage e converte pra um MAp
  Map<String, dynamic> _toFirestore (ChatMessage msg, SetOption? options){
    return{
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageURL': msg.userImageURL,
    };
  }
  */
  }
}
