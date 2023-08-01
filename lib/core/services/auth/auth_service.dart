/* Classe que vai delinear os métodos que serão precisos na parte de autenticação.

  Classe generica que representa uma interface que contém os métodos que precisão ser implementados
 */
import 'dart:io';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_firebase_services.dart';

abstract class AuthService {
  /* Usuário logado, é opcional pois se não tiver usuário logado o valor será nullo */
  ChatUser? get currentUser;

  /* Método que vai fazer com que a interface detecte que o usuário foi logado,
  
    Método gera uma stream de dados sempre que o usuário for modificado.
  */
  Stream<ChatUser?> get userChanges;

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  );
  Future<void> login(
    String email,
    String password,
  );

  Future<void> logout();

  /* Retornando uma implementação de uma classe genérica a partir dela mesma */
  factory AuthService() {
    // return AuthMockService();
    return AuthFirebaseService();
  }
}
