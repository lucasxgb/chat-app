/* Representa uma mensagem dentro do chat 

  Não estamos focando em modelagem no sql, ou aspectos relacionados ao firebase
  por isso que em alguns momentos ocorre uma duplicação de dados, para tornar 
  a obtenção de informações algo mais simples. 
*/

class ChatMessage {
  final String id;
  final String text;
  final DateTime createdAt;

  final String userId;
  final String userName;
  final String userImageURL;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userImageURL,
  });
}
