import 'package:firebase_realtime_chat/model/chat_message.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_viewmodel.dart';
import 'package:firebase_realtime_chat/views/individual_chat/widgets/bubbles.dart';
import 'package:firebase_realtime_chat/widgets.dart/textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

class ChatRoomView extends StackedView<ChatRoomViewModel> {
  final String? smsText;
  final UserModel senderMember;
  final UserModel receiverMember;
  final Color iconColor;
  final Color textFieldBorderColor;
  final int imageQuality;
  //   final UserModel userData;
  // final String defaultImage;
  // final AppBar? appBar;
  // final bool imageDownloadButton;
  // final Color ownerBubbleColor;
  // final Color otherBubbleColor;
  // const CommunityChatRoomView({
  //   Key? key,
  //   required this.userData,
  //   this.defaultImage =
  //       "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
  //   this.appBar,
  //   this.imageDownloadButton = false,
  //   this.ownerBubbleColor = const Color.fromARGB(255, 199, 249, 245),
  //   this.otherBubbleColor = const Color.fromARGB(255, 250, 236, 193),
  const ChatRoomView({
    Key? key,
    required this.senderMember,
    required this.receiverMember,
    this.smsText,
    this.iconColor = Colors.grey,
    this.textFieldBorderColor = Colors.blue,
    this.imageQuality = 25,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatRoomViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          senderMember.name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('ChatRooms')
                  .doc(mergeStrings(senderMember.userId, receiverMember.userId))
                  .collection('Messages')
                  .orderBy('createdOn', descending: true)
                  .snapshots(),
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
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    ChatMessage data = ChatMessage.fromJson(
                        document.data()! as Map<String, dynamic>);
                    return ChatRoomBubbles(
                      uID: senderMember.userId,
                      message: data,
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
              borderColor: textFieldBorderColor,
              onChanged: viewModel.onChanged,
              sufixIcon: viewModel.messageController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: viewModel.sendDummyMessage,
                      child: Icon(Icons.send, size: 18, color: iconColor),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            viewModel.sentGalleryImage(imageQuality);
                          },
                          child: Icon(Icons.attach_file,
                              size: 25, color: iconColor),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            viewModel.sentCameraImage(imageQuality);
                          },
                          child: Icon(Icons.camera_alt,
                              size: 28, color: iconColor),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(ChatRoomViewModel viewModel) {
    viewModel.onViewModelReady(senderMember, receiverMember, smsText);
    super.onViewModelReady(viewModel);
  }

  @override
  ChatRoomViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatRoomViewModel();
}
