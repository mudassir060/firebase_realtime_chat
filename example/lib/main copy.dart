import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';
import 'package:flutter/material.dart';

class OpenChatRoomView extends StatefulWidget {
  const OpenChatRoomView({super.key});

  @override
  State<OpenChatRoomView> createState() => _OpenChatRoomViewState();
}

class _OpenChatRoomViewState extends State<OpenChatRoomView> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoomView(
                    smsText: "",
                    senderMember: UserModel(
                      userId: "xyz",
                      name: "Mudassir",
                      profile:
                          "https://buffer.com/library/content/images/2023/10/free-images.jpg",
                    ),
                    receiverMember: UserModel(
                      userId: "abc",
                      name: "Ali",
                      profile:
                          "https://buffer.com/library/content/images/2023/10/free-images.jpg",
                    ),
                  ),
                ),
              );
            },
            child: const Text("inbox open")),
      ),
    );
  }
}
