import 'package:firebase_realtime_chat/model/chat_message.dart';
import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ChatRoomViewModel extends BaseViewModel {
  final _firestore = FirebaseFirestore.instance;
  // final CollectionReference _messagesCollection = FirebaseFirestore.instance
  //     .collection('ChatRooms')
  //     .doc("senderIdreceiverId")
  //     .collection('Messages');
  UserModel? senderMember;
  UserModel? receiverMember;
  TextEditingController messageController = TextEditingController();
  onViewModelReady(
      UserModel senderMember, UserModel receiverMember, String? smsText) {
    messageController.text = smsText ?? "";
    this.senderMember = senderMember;
    this.receiverMember = receiverMember;
  }

  onChanged(e) {
    notifyListeners();
  }

  sentCameraImage(int imageQuality) async {
    String image =
        await pickImage('CommunityChatRoom', ImageSource.camera, imageQuality);
    // sendMessage(url: image);
    notifyListeners();
  }

  sentGalleryImage(int imageQuality) async {
    String image =
        await pickImage('CommunityChatRoom', ImageSource.gallery, imageQuality);
    // sendMessage(url: image);
    notifyListeners();
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

    await startChatRoom(dummyMessage, dummyChatRoom);
    messageController.clear();
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
    String messageText = messageController.text;
    if (messageText.isNotEmpty) {
      DocumentReference roomRef =
          _firestore.collection('ChatRooms').doc(chatRoomId);
      DocumentReference messageRef = roomRef.collection('Messages').doc();
      await messageRef.set(message.toJson());
      messageController.clear();
      notifyListeners();
    }
  }
}
