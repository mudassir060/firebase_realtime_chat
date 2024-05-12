class ChatMessage {
  const ChatMessage({
    this.id,
    this.url = "",
    this.text = "",
    required this.type,
    required this.authorId,
    required this.createdOn,
  });

  final String? id;
  final String url;
  final String text;
  final String type;
  final String authorId;
  final DateTime createdOn;

  ChatMessage.fromJson(Map<String, dynamic> json, String messageId)
      : id = messageId,
        url = json['url'],
        text = json['text'],
        type = json['type'],
        authorId = json['authorId'],
        createdOn = DateTime.parse(json['createdOn']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'text': text,
        'type': type,
        'authorId': authorId,
        'createdOn': createdOn.toIso8601String(),
      };
}
