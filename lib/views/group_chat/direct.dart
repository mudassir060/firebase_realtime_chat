import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference _chatRoomCollection =
    FirebaseFirestore.instance.collection('GroupChat');

sentGroupImage({
  required String userId,
  required String name,
  required String profile,
  ImageSource source = ImageSource.camera,
}) async {
  String image = await pickImage('GroupChat', source);
  sendMessage(url: image, userId: userId, name: name, profile: profile);
}

sentGroupImageByFile(
    {required String userId,
    required String name,
    required String profile,
    required File file}) async {
  String image = await postImageOnFirebase('GroupChat', file);
  sendMessage(url: image, userId: userId, name: name, profile: profile);
}

Future<void> sendMessage({
  String messageText = "",
  String url = '',
  required String userId,
  required String name,
  required String profile,
}) async {
  ChatMessage dummyMessage = ChatMessage(
    text: messageText,
    authorId: userId,
    createdOn: DateTime.now(),
    authorName: name,
    authorProfile: profile,
    url: url,
  );
  if (messageText.isNotEmpty || url.isNotEmpty) {
    DocumentReference messageRef = _chatRoomCollection.doc();
    await messageRef.set(dummyMessage.toJson());
  }
}
