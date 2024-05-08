class ChatMessage {
  final String text;
  final String url;
  final String authorId;
  final String authorName;
  final String authorProfile;
  final DateTime createdOn;

  ChatMessage({
    required this.text,
    required this.url,
    required this.authorId,
    required this.authorName,
    required this.authorProfile,
    required this.createdOn,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      url: json['url'] ?? "",
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorProfile: json['authorProfile'],
      createdOn: json['createdOn'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'url': url,
      'authorId': authorId,
      'authorName': authorName,
      'authorProfile': authorProfile,
      'createdOn': createdOn,
    };
  }
}
