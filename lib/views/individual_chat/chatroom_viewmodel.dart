import 'package:firebase_realtime_chat/model/chat_message.dart';
import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/response.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ChatRoomViewModel extends BaseViewModel {
  final _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? get uId => _auth.currentUser?.uid;

  // final CollectionReference _messagesCollection = FirebaseFirestore.instance
  //     .collection('ChatRooms')
  //     .doc("senderIdreceiverId")
  //     .collection('Messages');
  UserModel? senderMember;
  UserModel? receiverMember;
  FocusNode focusNode = FocusNode();
  List<ChatMessage> messages = [];

  bool isShowEmjois = false;
  TextEditingController messageController = TextEditingController();
  onViewModelReady(
      UserModel senderMember, UserModel receiverMember, String? smsText) {
    messageController.text = smsText ?? "";
    this.senderMember = senderMember;
    this.receiverMember = receiverMember;
    listenToMessages().data?.listen((event) {
      messages = event;
      notifyListeners();
    });
  }

  onChanged(e) {
    notifyListeners();
  }

  sentCameraImage(int imageQuality) async {
    setBusy(true);
    String image =
        await pickImage('CommunityChatRoom', ImageSource.camera, imageQuality);
    if (image.isNotEmpty) {
      sentFile(url: image);
    }
    setBusy(false);
  }

  sentGalleryImage(int imageQuality) async {
    setBusy(true);
    String image =
        await pickImage('CommunityChatRoom', ImageSource.gallery, imageQuality);
    if (image.isNotEmpty) {
      sentFile(url: image);
    }
    setBusy(false);
  }

  sentFile({required String url}) async {
    ChatMessage message = ChatMessage(
      url: url,
      authorId: senderMember?.userId ?? "",
      createdOn: DateTime.now(),
      type: "image",
    );
    ChatRoom chatRoom = ChatRoom(
      membersId: [senderMember?.userId ?? "", receiverMember?.userId ?? ""],
      lastMessage: message,
      members: {
        'senderId': senderMember!,
        'receiverId': receiverMember!,
      },
      createdOn: DateTime.now(),
    );

    await startChatRoom(message, chatRoom);
  }

  showEmojis() {
    isShowEmjois = !isShowEmjois;
    focusNode.unfocus();
    notifyListeners();
  }

  sentEmojis(url) async {
    ChatMessage message = ChatMessage(
      url: url,
      authorId: senderMember?.userId ?? "",
      createdOn: DateTime.now(),
      type: "emoji",
    );
    ChatRoom chatRoom = ChatRoom(
      membersId: [senderMember?.userId ?? "", receiverMember?.userId ?? ""],
      lastMessage: message,
      members: {
        'senderId': senderMember!,
        'receiverId': receiverMember!,
      },
      createdOn: DateTime.now(),
    );

    await startChatRoom(message, chatRoom);
  }

  ResponseModel<Stream<List<ChatMessage>>> listenToMessages() {
    try {
      final stream = _firestore
          .collection('ChatRooms')
          .doc(mergeStrings(
              senderMember?.userId ?? "", receiverMember?.userId ?? ""))
          .collection('Messages')
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

  Future<void> sendDummyMessage() async {
    ChatMessage dummyMessage = ChatMessage(
      text: messageController.text,
      authorId: senderMember?.userId ?? "",
      createdOn: DateTime.now(),
      type: "text",
    );
    ChatRoom dummyChatRoom = ChatRoom(
      membersId: [senderMember?.userId ?? "", receiverMember?.userId ?? ""],
      lastMessage: dummyMessage,
      members: {
        'senderId': senderMember!,
        'receiverId': receiverMember!,
      },
      createdOn: DateTime.now(),
    );
    if (messageController.text.isNotEmpty) {
      messageController.clear();
      await startChatRoom(dummyMessage, dummyChatRoom);
    }
  }

  Future<String> startChatRoom(ChatMessage message, ChatRoom chatRoom) async {
    final ref = _firestore.collection('ChatRooms').doc(
        mergeStrings(senderMember?.userId ?? "", receiverMember?.userId ?? ""));
    await ref.set(chatRoom.toJson());
    final roomId = ref.id;
    await sendMessage(message, roomId);
    return roomId;
  }

  Future<void> sendMessage(ChatMessage message, String chatRoomId) async {
    DocumentReference roomRef =
        _firestore.collection('ChatRooms').doc(chatRoomId);
    DocumentReference messageRef = roomRef.collection('Messages').doc();
    await messageRef.set(message.toJson());
    notifyListeners();
  }

  void showDeleteConfirmation(BuildContext context, String messageId) {
    DocumentReference roomRef = _firestore.collection('ChatRooms').doc(
        mergeStrings(senderMember?.userId ?? "", receiverMember?.userId ?? ""));
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
                roomRef.collection('Messages').doc(messageId).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
