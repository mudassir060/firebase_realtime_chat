import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/model/response.dart';
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
  UserModel? userData;
  List<ChatMessage> messages = [];
  FocusNode focusNode = FocusNode();

  bool isShowEmjois = false;

  onViewModelReady(UserModel userData) {
    setBusy(true);
    this.userData = userData;
    listenToMessages().data?.listen((event) {
      messages = event;
      notifyListeners();
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmjois = false;
        notifyListeners();
      }
    });
    setBusy(false);
  }

  onChanged(e) {
    notifyListeners();
  }

  ResponseModel<Stream<List<ChatMessage>>> listenToMessages() {
    try {
      final stream = FirebaseFirestore.instance
          .collection('CommunityChatRoom')
          .orderBy('createdOn', descending: true)
          .snapshots()
          .map((event) {
        List<ChatMessage> products = [];
        for (var item in event.docs) {
          products.add(ChatMessage.fromJson(item.data(), item.id));
        }
        return products;
      });
      return ResponseModel.completed(stream);
    } catch (e) {
      return ResponseModel.error(
          'Error listening from listenToLimtedPosts: $e');
    }
  }

  sentCameraImage(int imageQuality) async {
    String image =
        await pickImage('CommunityChatRoom', ImageSource.camera, imageQuality);
    if (image.isNotEmpty) {
      sendMessage(url: image);
    }
  }

  sentGalleryImage(int imageQuality) async {
    String image =
        await pickImage('CommunityChatRoom', ImageSource.gallery, imageQuality);
    if (image.isNotEmpty) {
      sendMessage(url: image);
    }
  }

  showEmojis() {
    isShowEmjois = !isShowEmjois;
    focusNode.unfocus();
    notifyListeners();
  }

  sentEmojis(url) {
    sendMessage(url: url);
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
