import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_viewmodel.dart';
import 'package:firebase_realtime_chat/views/individual_chat/widgets/bubbles.dart';
import 'package:firebase_realtime_chat/widgets.dart/emoji.dart';
import 'package:firebase_realtime_chat/widgets.dart/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatRoomView extends StackedView<ChatRoomViewModel> {
  final String? smsText;
  final UserModel senderMember;
  final UserModel receiverMember;
  final Color iconColor;
  final Color textFieldBorderColor;
  final int imageQuality;
  final String defaultImage;
  final AppBar? appBar;
  final bool imageDownloadButton;
  final Color ownerBubbleColor;
  final Color otherBubbleColor;

  const ChatRoomView({
    super.key,
    required this.senderMember,
    required this.receiverMember,
    this.smsText,
    this.iconColor = Colors.grey,
    this.textFieldBorderColor = Colors.blue,
    this.imageQuality = 25,
    this.defaultImage =
        "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
    this.appBar,
    this.imageDownloadButton = false,
    this.ownerBubbleColor = const Color.fromARGB(255, 199, 249, 245),
    this.otherBubbleColor = const Color.fromARGB(255, 250, 236, 193),
  });

  @override
  Widget builder(
    BuildContext context,
    ChatRoomViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              receiverMember.name,
              style: const TextStyle(color: Colors.black),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('status')
                    .doc(receiverMember.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var userDoc = snapshot.data!;
                    var userData = userDoc.data();
                    bool isOnline = false;
                    String lastSeen = '';
                    if (userData is Map<String, dynamic>) {
                      isOnline = userData['isOnline'] ?? false;
                      if (userData['lastSeen'] != null) {
                        lastSeen = timeAgo(userData['lastSeen'].toDate());
                      } else {
                        lastSeen = '';
                      }
                    }
                    return Text(
                      isOnline ? 'Online' : lastSeen,
                      style: TextStyle(
                        color: isOnline ? Colors.green : Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  }
                  return Container();
                })
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: viewModel.messages.length,
                      itemBuilder: (context, index) {
                        return ChatRoomBubbles(
                          message: viewModel.messages[index],
                          currentUserUID: senderMember.userId,
                          defaultImage: defaultImage,
                          imageDownloadButton: imageDownloadButton,
                          ownerBubbleColor: ownerBubbleColor,
                          otherBubbleColor: otherBubbleColor,
                        );
                      })),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Textfield(
                  title: "Type a message...",
                  ctrl: viewModel.messageController,
                  borderColor: textFieldBorderColor,
                  onChanged: viewModel.onChanged,
                  focusNode: viewModel.focusNode,
                  prefixIcon: GestureDetector(
                    onTap: viewModel.showEmojis,
                    child: Icon(Icons.emoji_emotions_outlined,
                        size: 32, color: iconColor),
                  ),
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
              if (viewModel.isShowEmjois)
                EmojiKeyboard(onSelecte: viewModel.sentEmojis)
            ],
          ),
          if (viewModel.isBusy)
            Center(
              child: foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(),
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
