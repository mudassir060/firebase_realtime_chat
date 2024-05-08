class ChatMember {
  final String userId;
  final String displayName;

  ChatMember({
    required this.userId,
    required this.displayName,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      userId: json['userId'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
    };
  }
}
