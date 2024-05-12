import 'package:firebase_realtime_chat/views/community_chat_room/community_chat_room_model.dart';
import 'package:firebase_realtime_chat/views/community_chat_room/widgets/bubbles.dart';
import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/widgets.dart/emoji.dart';
import 'package:firebase_realtime_chat/widgets.dart/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart' as foundation;

class CommunityChatRoomView extends StatelessWidget {
  final UserModel userData;
  final Color textFieldBorderColor;
  final String defaultImage;
  final AppBar? appBar;
  final Color iconColor;
  final int imageQuality;
  final bool imageDownloadButton;
  final Color ownerBubbleColor;
  final Color otherBubbleColor;
  const CommunityChatRoomView({
    Key? key,
    required this.userData,
    this.textFieldBorderColor = Colors.blue,
    this.defaultImage =
        "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
    this.appBar,
    this.iconColor = Colors.grey,
    this.imageQuality = 25,
    this.imageDownloadButton = false,
    this.ownerBubbleColor = const Color.fromARGB(255, 199, 249, 245),
    this.otherBubbleColor = const Color.fromARGB(255, 250, 236, 193),
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
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: viewModel.messages.length,
                          itemBuilder: (context, index) {
                            ChatMessage message = viewModel.messages[index];
                            return CommunityChatRoomBubbles(
                              message: message,
                              currentUserUID: userData.userId,
                              defaultImage: defaultImage,
                              imageDownloadButton: imageDownloadButton,
                              ownerBubbleColor: ownerBubbleColor,
                              otherBubbleColor: otherBubbleColor,
                            );
                          }),
                    ),
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
                                onTap: viewModel.sendMessage,
                                child: Icon(Icons.send,
                                    size: 18, color: iconColor),
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
                    child:
                        foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
