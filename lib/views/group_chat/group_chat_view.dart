import 'package:firebase_realtime_chat/views/group_chat/group_chat_model.dart';
import 'package:firebase_realtime_chat/views/group_chat/widgets/bubbles.dart';
import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/widgets.dart/textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

class ChatRoomView extends StatelessWidget {
  final UserModel userData;
  final Color textFieldBorderColor;
  final String profileAssetsImage;
  const ChatRoomView({
    Key? key,
    required this.userData,
    this.textFieldBorderColor = Colors.blue,
    required this.profileAssetsImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GroupChatViewModel>.reactive(
      viewModelBuilder: () => GroupChatViewModel(),
      onViewModelReady: (viewModel) => viewModel.onViewModelReady(userData),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
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
                              document.data()! as Map<String, dynamic>);
                          return ChatRoomBubbles(
                            message: data,
                            currentUserUID: userData.userId,
                            profileAssetsImage: profileAssetsImage,
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
                        : GestureDetector(
                            onTap: viewModel.sentImage,
                            child: const Icon(Icons.attach_file, size: 18),
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
