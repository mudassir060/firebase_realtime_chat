// ignore_for_file: must_be_immutable
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  UserModel user1 = UserModel(
    userId: "xyz",
    email: "xyz@gmail.com",
    name: "Mudassir",
    profile:
        "https://buffer.com/library/content/images/2023/10/free-images.jpg",
  );
  UserModel user2 = UserModel(
    userId: "asdf",
    email: "asdf@gmail.com",
    name: "Farhan",
    profile:
        "https://h5p.org/sites/default/files/h5p/content/1209180/images/file-6113d5f8845dc.jpeg",
  );
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
      home: ChatView(userData: user1),
    );
  }
}
