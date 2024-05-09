import 'package:firebase_realtime_chat/model/chat_message.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatRoomBubbles extends ViewModelWidget<ChatRoomViewModel> {
  final ChatMessage message;
  final String uID;
  const ChatRoomBubbles({Key? key, required this.message, required this.uID})
      : super(key: key);

  @override
  Widget build(
    BuildContext context,
    ChatRoomViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 14, right: 14),
      child: Align(
        alignment: (message.authorId == uID
            ? Alignment.bottomRight
            : Alignment.topLeft),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: (message.authorId == uID
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(0))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(20))),
              color: (message.authorId == uID
                  ? Colors.teal.shade100
                  : Colors.amber.shade100),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Column(
              crossAxisAlignment: message.authorId == uID
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  message.text.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  timeAgo(message.createdOn),
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                )
              ],
            )),
      ),
    );
  }
}
