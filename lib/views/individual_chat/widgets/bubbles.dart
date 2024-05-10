import 'package:firebase_realtime_chat/model/chat_message.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/views/image_view/image_view.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChatRoomBubbles extends ViewModelWidget<ChatRoomViewModel> {
  final ChatMessage message;
  final Color ownerBubbleColor;
  final Color otherBubbleColor;
  final String currentUserUID;
  final String defaultImage;
  final bool imageDownloadButton;

  const ChatRoomBubbles({
    Key? key,
    required this.ownerBubbleColor,
    required this.otherBubbleColor,
    required this.message,
    required this.currentUserUID,
    required this.defaultImage,
    this.imageDownloadButton = false,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    ChatRoomViewModel viewModel,
  ) {
    final bool isCurrentUserMessage = message.authorId == currentUserUID;

    return GestureDetector(
      onLongPress: () {
        viewModel.showDeleteConfirmation(context, message.id ?? "");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
        child: Align(
          alignment: isCurrentUserMessage
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                decoration: BoxDecoration(
                  color: isCurrentUserMessage
                      ? ownerBubbleColor
                      : otherBubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isCurrentUserMessage ? 10.0 : 0),
                    topRight: const Radius.circular(10.0),
                    bottomLeft: const Radius.circular(10.0),
                    bottomRight:
                        Radius.circular(isCurrentUserMessage ? 0 : 10.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: isCurrentUserMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (message.text.isNotEmpty)
                      Text(
                        message.text.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    if (message.url.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                url: message.url,
                                imageDownloadButton: imageDownloadButton,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          message.url,
                          width: MediaQuery.of(context).size.width / 2.5,
                        ),
                      ),
                    const SizedBox(height: 1.0),
                    Text(
                      timeAgo(message.createdOn),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
