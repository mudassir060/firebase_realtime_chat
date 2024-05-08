import 'package:firebase_realtime_chat/firebase_realtime_chat.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChatRoomView(
        userData: UserModel(
          userId: "xyz",
          email: "xyz@gmail.com",
          name: "Mudassir",
          profile:
              "https://buffer.com/library/content/images/2023/10/free-images.jpg",
        ),
        profileAssetsImage: "assets/images/profile.jpeg",
      ),
    );
  }
}
