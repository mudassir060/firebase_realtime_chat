import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chat_viewmodel.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatView extends StackedView<ChatViewModel> {
  final Color iconColor;
  final Color textFieldBorderColor;
  final int imageQuality;
  final UserModel userData;
  final String defaultImage;
  final AppBar? appBar;
  final bool imageDownloadButton;
  final Color ownerBubbleColor;
  final Color otherBubbleColor;

  const ChatView({
    Key? key,
    required this.userData,
    this.iconColor = Colors.grey,
    this.textFieldBorderColor = Colors.blue,
    this.imageQuality = 25,
    this.defaultImage =
        "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
    this.appBar,
    this.imageDownloadButton = false,
    this.ownerBubbleColor = const Color.fromARGB(255, 199, 249, 245),
    this.otherBubbleColor = const Color.fromARGB(255, 250, 236, 193),
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            centerTitle: true,
            title: const Text("Firebase Realtime Individual Chat"),
          ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: viewModel.chatRooms.length,
              itemBuilder: (context, index) {
                ChatRoom chatRoom = viewModel.chatRooms[index];
                return InkWell(
                  onTap: () {
                    UserModel? otherUser =
                        chatRoom.members["senderId"]?.userId == userData.userId
                            ? chatRoom.members["receiverId"]
                            : chatRoom.members["senderId"];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomView(
                          iconColor: iconColor,
                          textFieldBorderColor: textFieldBorderColor,
                          imageQuality: imageQuality,
                          defaultImage: defaultImage,
                          imageDownloadButton: imageDownloadButton,
                          ownerBubbleColor: ownerBubbleColor,
                          otherBubbleColor: otherBubbleColor,
                          senderMember: UserModel(
                            userId: userData.userId,
                            name: userData.name,
                            profile: userData.profile,
                          ),
                          receiverMember: UserModel(
                            userId: otherUser?.userId ?? "",
                            name: otherUser?.name ?? "",
                            profile: otherUser?.profile ?? "",
                          ),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage((viewModel
                                        .userData?.userId !=
                                    chatRoom.members["senderId"]?.userId
                                ? chatRoom.members["senderId"]?.profile
                                : chatRoom.members["receiverId"]?.profile) ??
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUUfNCnMwMeh_5WuKXe55VTTVQcF1CN7Yb6Jw5TWYcngvaPF_z7yapb8o0PCoQMVv3UTs&usqp=CAU"),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userData.userId != chatRoom.members["senderId"]?.userId ? chatRoom.members["senderId"]?.name : chatRoom.members["receiverId"]?.name}",
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            maxLines: 1,
                            ((chatRoom.lastMessage?.text ?? "").isNotEmpty
                                    ? chatRoom.lastMessage?.text
                                    : (chatRoom.lastMessage?.url ?? "")
                                            .isNotEmpty
                                        ? chatRoom.lastMessage?.type
                                        : "")
                                .toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Text(timeAgo(chatRoom.lastMessage!.createdOn)),
                    ),
                  ),
                );
              }),
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
  void onViewModelReady(ChatViewModel viewModel) {
    viewModel.onViewModelReady(userData);
    super.onViewModelReady(viewModel);
  }

  @override
  ChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatViewModel();
}
