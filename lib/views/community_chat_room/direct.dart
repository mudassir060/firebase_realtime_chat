import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference _chatRoomCollection =
    FirebaseFirestore.instance.collection('CommunityChatRoom');

sentCommunityImage({
  required String userId,
  required String name,
  required String profile,
  int imageQuality = 25,
  ImageSource source = ImageSource.camera,
}) async {
  String image = await pickImage('CommunityChatRoom', source, imageQuality);
  sendCommunityMessage(url: image, userId: userId, name: name, profile: profile);
}

sentCommunityImageByFile(
    {required String userId,
    required String name,
    required String profile,
    required File file}) async {
  String image = await postImageOnFirebase('CommunityChatRoom', file);
  sendCommunityMessage(url: image, userId: userId, name: name, profile: profile);
}

Future<void> sendCommunityMessage({
  String messageText = "",
  String url = '',
  required String userId,
  required String name,
  required String profile,
}) async {
  ChatMessage dummyMessage = ChatMessage(
    text: messageText,
    ownerId: userId,
    createdOn: DateTime.now(),
    ownerName: name,
    ownerProfile: profile,
    url: url,
  );
  if (messageText.isNotEmpty || url.isNotEmpty) {
    DocumentReference messageRef = _chatRoomCollection.doc();
    await messageRef.set(dummyMessage.toJson());
  }
}
