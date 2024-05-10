import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chat_viewmodel.dart';
import 'package:firebase_realtime_chat/views/individual_chat/chatroom_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
      body: Column(
        children: [
          StreamBuilder<List<ChatRoom>>(
            stream: viewModel.getChatRoomsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ChatRoom> chatRooms = snapshot.data!;
                return Column(
                  children: chatRooms.map((chatRoom) {
                    return InkWell(
                      onTap: () {
                        UserModel? otherUser =
                            chatRoom.members["senderId"]?.userId ==
                                    userData.userId
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
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage((viewModel
                                            .userData?.userId !=
                                        chatRoom.members["senderId"]?.userId
                                    ? chatRoom.members["senderId"]?.profile
                                    : chatRoom
                                        .members["receiverId"]?.profile) ??
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
                                chatRoom.lastMessage?.text ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
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
