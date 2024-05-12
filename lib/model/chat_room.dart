import 'package:firebase_realtime_chat/model/user.dart';
import 'chat_message.dart';

class ChatRoom {
  const ChatRoom({
    this.id,
    this.lastMessage,
    required this.createdOn,
    this.type,
    this.subscriptionType,
    required this.membersId,
    required this.members,
    this.updatedOn,
  });

  final String? id;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final String? type;
  final String? subscriptionType;
  final ChatMessage? lastMessage;
  final Map<String, UserModel> members;
  final List<String> membersId;

  ChatRoom.fromJson(Map<String, dynamic> json, String id)
      : id = json['id'] ?? id,
        createdOn = DateTime.parse(json['createdOn']),
        updatedOn = json['updatedOn'] != null
            ? DateTime.parse(json['updatedOn'])
            : null,
        type = json['type'],
        subscriptionType = json['subscriptionType'],
        lastMessage = json['lastMessage'] != null
            ? ChatMessage.fromJson(json['lastMessage'], "")
            : null,
        membersId = List<String>.from(json['membersId']),
        members = Map<String, UserModel>.from(
          json['members'].map(
            (key, value) => MapEntry(key, UserModel.fromJson(value)),
          ),
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdOn': createdOn.toIso8601String(),
        'updatedOn': updatedOn?.toIso8601String(),
        'type': type,
        'subscriptionType': subscriptionType,
        'lastMessage': lastMessage?.toJson(),
        'membersId': membersId,
        'members': Map.fromEntries(
          members.entries.map(
            (e) => MapEntry(e.key, e.value.toJson()),
          ),
        ),
      };
}
