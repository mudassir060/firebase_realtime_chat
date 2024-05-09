import 'package:firebase_realtime_chat/views/community_chat_room/community_chat_room_model.dart';
import 'package:firebase_realtime_chat/model/chat_messages.dart';
import 'package:firebase_realtime_chat/views/image_view/image_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityChatRoomBubbles
    extends ViewModelWidget<CommunityChatRoomViewModel> {
  final ChatMessage message;
  final String currentUserUID;
  final String defaultImage;

  const CommunityChatRoomBubbles({
    Key? key,
    required this.message,
    required this.currentUserUID,
    required this.defaultImage,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    CommunityChatRoomViewModel viewModel,
  ) {
    final bool isCurrentUserMessage =
        message.authorId == viewModel.userData?.userId;

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
              if (!isCurrentUserMessage)
                message.authorProfile.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageView(url: message.authorProfile),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(message.authorProfile),
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(defaultImage),
                      ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                decoration: BoxDecoration(
                  color: isCurrentUserMessage
                      ? const Color.fromARGB(255, 199, 249, 245)
                      : const Color.fromARGB(255, 250, 236, 193),
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
                    if (!isCurrentUserMessage)
                      Text(
                        message.authorName.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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
                              builder: (context) => ImageView(url: message.url),
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
                      timeago.format(message.createdOn),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrentUserMessage)
                message.authorProfile.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageView(url: message.authorProfile),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(message.authorProfile),
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(defaultImage),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
