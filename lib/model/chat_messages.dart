class ChatMessage {
  final String? id;
  final String text;
  final String url;
  final String ownerId;
  final String ownerName;
  final String ownerProfile;
  final DateTime createdOn;

  ChatMessage({
    this.id,
    required this.text,
    required this.url,
    required this.ownerId,
    required this.ownerName,
    required this.ownerProfile,
    required this.createdOn,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String smsId) {
    return ChatMessage(
      id: smsId,
      text: json['text'],
      url: json['url'] ?? "",
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      ownerProfile: json['ownerProfile'],
      createdOn: json['createdOn'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'url': url,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerProfile': ownerProfile,
      'createdOn': createdOn,
    };
  }
}
