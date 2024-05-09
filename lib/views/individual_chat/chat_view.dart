import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'individual_chat_viewmodel.dart';

class ChatView extends StackedView<ChatViewModel> {
  final UserModel userData;

  const ChatView({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
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
                            chatRoom.members["senderId"]?.userId !=
                                    userData.userId
                                ? chatRoom.members["receiverId"]
                                : chatRoom.members["senderId"];
                        viewModel.navigateToChatRoomView(
                            UserModel(
                              userId: userData.userId,
                              name: userData.name,
                              profile: userData.profile,
                            ),
                            UserModel(
                              userId: otherUser?.userId ?? "",
                              name: otherUser?.name ?? "",
                              profile: otherUser?.profile ?? "",
                            ),
                            context);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(2),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage((viewModel
                                            .userData?.userId ==
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
                                "${userData.userId == chatRoom.members["senderId"]?.userId ? chatRoom.members["senderId"]?.name : chatRoom.members["receiverId"]?.name}",
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
