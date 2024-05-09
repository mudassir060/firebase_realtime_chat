import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityChatRoomViewModel extends BaseViewModel {
  final CollectionReference _chatRoomCollection =
      FirebaseFirestore.instance.collection('CommunityChatRoom');

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

  sentCameraImage(int imageQuality) async {
    String image =
        await pickImage('CommunityChatRoom', ImageSource.camera, imageQuality);
    sendMessage(url: image);
    notifyListeners();
  }

  sentGalleryImage(int imageQuality) async {
    String image =
        await pickImage('CommunityChatRoom', ImageSource.gallery, imageQuality);
    sendMessage(url: image);
    notifyListeners();
  }

  Future<void> sendMessage({String url = ''}) async {
    ChatMessage dummyMessage = ChatMessage(
      text: messageController.text,
      ownerId: userData?.userId ?? "",
      createdOn: DateTime.now(),
      ownerName: userData?.name ?? "",
      ownerProfile: userData?.profile ?? "",
      url: url,
    );
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty || url.isNotEmpty) {
      DocumentReference messageRef = _chatRoomCollection.doc();
      await messageRef.set(dummyMessage.toJson());
    }
    messageController.clear();
    notifyListeners();
  }

  void showDeleteConfirmation(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Message"),
          content: const Text("Are you sure you want to delete this message?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                _chatRoomCollection.doc(messageId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
