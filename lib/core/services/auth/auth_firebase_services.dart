/* Classe mockada para implementação de AuthService, ou seja ela segue o modelo definido
dentro da classe abstrada AuthService*/

import 'dart:async';
import 'dart:io';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  // static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    /* Mudanças, sempre que o stream do firebase modificar eu quero que o stream de chat
    user também seja modificado */
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });
  /* Ao fazer váris instâncias de AuthFirebaseService, eu ainda vou ter o mesmo usuário 
  logado*/
  static ChatUser? _currentUser;

  ChatUser? get currentUser {
    return _currentUser;
  }

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
      String name, String email, String password, File? image) async {
    final auth = FirebaseAuth.instance;

    /* Criando usuário com email e senha */
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user == null) return;

    // 1. Upload da foto do usuário
    final imageName = '${userCredential.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, imageName);

    /* 2. Método para atualizar os atributos do usuário  */
    await userCredential.user?.updateDisplayName(name);
    await userCredential.user?.updatePhotoURL(imageURL);

    /* 3. Salvar usuário no banco de dados (opcional) */
    await _saveChatUser(_toChatUser(userCredential.user!, imageURL));
  }

  /* Método para fazer o login, internamente o fire base já faz tudo,
  o código que está escutando as mudanças na parte de autenticação no `authChanges`, quando chega 
  uma autenticação ele já adiciona o usuário dentro do _userStream */
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    /* Depêndencia do firebase para logout */
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);

    /* Espera ele realizar o upload da imagem  */
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  static void _updateUser(ChatUser? user) {}

  /* Método para salvar um usuário, no FireStore ao ínves de termos um arquivo
  terá um documento */
  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    /* Criando uma coleção que terá um documento */
    final docRef = store.collection('users').doc(user.id);

    /* Salvar o objeto com as informações que eu quero persistir no banco */
    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURl': user.imageUrl,
    });
  }

  static ChatUser _toChatUser(User user, [String? imageURL]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageURL ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }



}
