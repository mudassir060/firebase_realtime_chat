import 'package:firebase_realtime_chat/views/community_chat_room/community_chat_room_model.dart';
import 'package:firebase_realtime_chat/views/community_chat_room/widgets/bubbles.dart';
import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/widgets.dart/textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

class CommunityChatRoomView extends StatelessWidget {
  final UserModel userData;
  final Color textFieldBorderColor;
  final String defaultImage;
  final AppBar? appBar;
  final Color iconColor;
  const CommunityChatRoomView({
    Key? key,
    required this.userData,
    this.textFieldBorderColor = Colors.blue,
    this.defaultImage =
        "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
    this.appBar,
    this.iconColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommunityChatRoomViewModel>.reactive(
      viewModelBuilder: () => CommunityChatRoomViewModel(),
      onViewModelReady: (viewModel) => viewModel.onViewModelReady(userData),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: appBar ??
              AppBar(
                centerTitle: true,
                title: const Text("Firebase Realtime Chat"),
              ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: viewModel.messagesStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      return ListView(
                        reverse: true,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          ChatMessage data = ChatMessage.fromJson(
                              document.data()! as Map<String, dynamic>,
                              document.id);
                          return CommunityChatRoomBubbles(
                            message: data,
                            currentUserUID: userData.userId,
                            defaultImage: defaultImage,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Textfield(
                    title: "Type a message...",
                    ctrl: viewModel.messageController,
                    onChanged: viewModel.onChanged,
                    sufixIcon: viewModel.messageController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: viewModel.sendMessage,
                            child: const Icon(Icons.send, size: 18),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: viewModel.sentGalleryImage,
                                child: const Icon(Icons.attach_file, size: 25),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: viewModel.sentCameraImage,
                                child: const Icon(Icons.camera_alt, size: 28),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
