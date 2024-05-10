// ignore_for_file: must_be_immutable
import 'package:firebase_realtime_chat/firebase_realtime_chat.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chat_view.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

UserModel user1 = UserModel(
  userId: "xyz",
  email: "xyz@gmail.com",
  name: "Mudassir",
  profile: "https://buffer.com/library/content/images/2023/10/free-images.jpg",
);
UserModel user2 = UserModel(
  userId: "asdf",
  email: "asdf@gmail.com",
  name: "Farhan",
  profile:
      "https://h5p.org/sites/default/files/h5p/content/1209180/images/file-6113d5f8845dc.jpeg",
);
UserModel otherUser = UserModel(
  userId: "abc",
  email: "abc@gmail.com",
  name: "Ali",
  profile: "https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg",
);

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: CommunityChatRoomView(
      //   imageDownloadButton: true,
      //   // iconColor: Colors.green,
      //   // textFieldBorderColor: Colors.green,
      //   // ownerBubbleColor: const Color.fromARGB(255, 222, 197, 160),
      //   // otherBubbleColor: Color.fromARGB(255, 146, 202, 210),
      //   userData: user2,
      // ),
      // home: OpenChatRoomView(),
      home: ChatView(userData: otherUser),
    );
  }
}

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
                    senderMember: otherUser,
                    receiverMember: user1,
                  ),
                ),
              );
            },
            child: const Text("inbox open")),
      ),
    );
  }
}
