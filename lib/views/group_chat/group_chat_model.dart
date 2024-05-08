import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/image_picker_service.dart';
import 'package:stacked/stacked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChatViewModel extends BaseViewModel {
  final CollectionReference _chatRoomCollection =
      FirebaseFirestore.instance.collection('ChatRooms');

  TextEditingController messageController = TextEditingController();
  late Stream<QuerySnapshot> messagesStream = const Stream.empty();
  UserModel? userData;

  onViewModelReady(UserModel userData) {
    this.userData = userData;
    messagesStream =
        _chatRoomCollection.orderBy('createdOn', descending: true).snapshots();
  }

  onChanged(e) {
    notifyListeners();
  }

  sentImage() async {
    String image = await pickImage('GroupChat');
    sendMessage(url: image);
    notifyListeners();
  }

  Future<void> sendMessage({String url = ''}) async {
    ChatMessage dummyMessage = ChatMessage(
      text: messageController.text,
      authorId: userData?.userId ?? "",
      createdOn: DateTime.now(),
      authorName: userData?.name ?? "",
      authorProfile: userData?.profile ?? "",
      url: url,
    );
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty || url.isNotEmpty) {
      DocumentReference messageRef = _chatRoomCollection.doc();
      await messageRef.set(dummyMessage.toJson());
    }
    messageController.clear();
  }

  navigateToImageView(url) {
    // _navigationService.navigateToImageView(url: url);
  }
}
