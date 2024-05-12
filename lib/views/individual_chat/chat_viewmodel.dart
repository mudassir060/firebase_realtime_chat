import 'package:firebase_realtime_chat/model/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_realtime_chat/model/response.dart';
import 'package:firebase_realtime_chat/model/user.dart';
import 'package:stacked/stacked.dart';

class ChatViewModel extends BaseViewModel {
  final _firestore = FirebaseFirestore.instance;
  UserModel? userData;
  List<ChatRoom> chatRooms = [];

  onViewModelReady(UserModel userData) {
    setBusy(true);
    this.userData = userData;
    listenToChatRooms().data?.listen((event) {
      chatRooms = event;
      notifyListeners();
    });
    setBusy(false);
  }

  ResponseModel<Stream<List<ChatRoom>>> listenToChatRooms() {
    try {
      final stream = _firestore
          .collection('ChatRooms')
          .where('membersId', arrayContains: userData?.userId)
          .orderBy('lastMessage.createdOn', descending: true)
          .snapshots()
          .map((event) {
        List<ChatRoom> products = [];
        for (var item in event.docs) {
          products.add(ChatRoom.fromJson(item.data(), item.id));
        }
        return products;
      });
      return ResponseModel.completed(stream);
    } catch (e) {
      return ResponseModel.error(
          'Error listening from listenToLimtedPosts: $e');
    }
  }

  // navigateToChatRoomView(
  //     UserModel senderMember, UserModel receiverMember, BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChatRoomView(
  //           senderMember: senderMember,
  //           receiverMember: receiverMember,
  //           userData: userData!),
  //     ),
  //   );
  // }
}
