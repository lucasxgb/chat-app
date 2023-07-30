/* Classe responsável por armazenar os dados do usuário logado */
class ChatUser {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  const ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}
