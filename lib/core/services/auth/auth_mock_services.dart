/* Classe mockada para implementação de AuthService, ou seja ela segue o modelo definido
dentro da classe abstrada AuthService*/

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  /* Ao utilizar o static, indepente da instância da classe, eu vou ter os mesmos
  usuários cadastrados*/
  static Map<String, ChatUser> _users = {};
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(null);
  });

  /* Ao fazer váris instâncias de AuthMockService, eu ainda vou ter o mesmo usuário 
  logado*/
  static ChatUser? _currentUser;

  ChatUser? get currentUser {
    return _currentUser;
  }

  /* Sempre que houver uma mudança no estado do usuário o stream receberá um novo valor,
  e quem estiver monitorando será notificado */
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
      String name, String email, String password, File? image) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageUrl: image?.path ?? 'assets/images/avatar.png',
    );

    /* Se tiver ausente no map ele irá adicionar */
    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  Future<void> login(String email, String password) async {
    /* Se encontrar um usuário dentro do map, irá setar esse usuário como o usuário logado, 
    gerando um novo dado na stream. */
    _updateUser(_users[email]);
  }

  Future<void> logout() async {
    _updateUser(null);
  }

  /* Se o valor for diferente de nulloo, seta o usuário corrente gerando um novo valor na stream*/
  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
