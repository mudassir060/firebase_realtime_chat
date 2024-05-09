import 'dart:developer';
import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatViewModel extends BaseViewModel {
  final _firestore = FirebaseFirestore.instance;
  UserModel? userData;

  onViewModelReady(UserModel userData) {
    this.userData = userData;
  }

  Stream<List<ChatRoom>> getChatRoomsStream() async* {
    try {
      final result = _firestore
          .collection('ChatRooms')
          .where('membersId', arrayContains: userData?.userId)
          .orderBy('lastMessage.createdOn', descending: true)
          .snapshots();
      await for (final event in result) {
        final List<ChatRoom> chatRooms = List.empty(growable: true);
        for (final doc in event.docs) {
          final data = doc.data();
          try {
            chatRooms.add(ChatRoom.fromJson(data, doc.id));
          } catch (e) {
            log("${doc.reference.path} ==-=-=-=$e");
          }
        }
        yield chatRooms;
      }
    } catch (e, stack) {
      log("$e $stack");
    }
  }

  navigateToChatRoomView(
      UserModel senderMember, UserModel receiverMember, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomView(
            senderMember: senderMember, receiverMember: receiverMember),
      ),
    );
  }
}
