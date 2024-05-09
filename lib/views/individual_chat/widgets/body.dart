// import 'package:firebase_realtime_chat/model/ui/common/common/custom_text_field/custom_text_field.dart';
// import 'package:firebase_realtime_chat/model/ui/common/common/text.dart';
// import 'package:flutter/material.dart';

// import 'package:stacked/stacked.dart';

// import '../chat_viewmodel.dart';

// class ChatBody extends ViewModelWidget<ChatViewModel> {
//   const ChatBody({Key? key}) : super(key: key);

//   @override
//   Widget build(
//     BuildContext context,
//     ChatViewModel viewModel,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 5,
//         horizontal: 14,
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//                 itemCount: viewModel.message.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     padding: const EdgeInsets.only(
//                         top: 10, bottom: 10, left: 14, right: 14),
//                     child: Align(
//                       alignment:
//                           (viewModel.message[index].messageType == "recieve"
//                               ? Alignment.topLeft
//                               : Alignment.bottomRight),
//                       child: Container(
//                           decoration: BoxDecoration(
//                             // borderRadius: BorderRadius.circular(20),
//                             borderRadius:
//                                 (viewModel.message[index].messageType ==
//                                         "recieve"
//                                     ? const BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                         bottomLeft: Radius.circular(0),
//                                         bottomRight: Radius.circular(20))
//                                     : const BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                         bottomLeft: Radius.circular(20),
//                                         bottomRight: Radius.circular(0))),
//                             color: (viewModel.message[index].messageType ==
//                                     "recieve"
//                                 ? Colors.blueGrey
//                                 : Colors.amber),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 6, horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               CustomText(
//                                 text: viewModel.message[index].messageContent
//                                     .toString(),
//                                 color: (viewModel.message[index].messageType ==
//                                         "recieve"
//                                     ? Colors.black
//                                     : Colors.white),
//                               ),
//                               CustomText(
//                                 text: "08:00AM",
//                                 fontSize: 10,
//                                 color: (viewModel.message[index].messageType ==
//                                         "recieve"
//                                     ? Colors.blueGrey
//                                     : Colors.white),
//                               )
//                             ],
//                           )),
//                     ),
//                   );
//                 }),
//           ),
//           CustomTextField(
//             suffix: CircleAvatar(
//               radius: 22,
//               backgroundColor: Colors.blue,
//               child: Center(
//                 child: SizedBox(
//                   width: 30,
//                   height: 30,

//                   // child: Image.asset(
//                   //   send,
//                   // ),
//                 ),
//               ),
//             ),
//             hintText: "Type your message here..",
//             radius: 20,
//             hintStyle: const TextStyle(color: Colors.blueGrey),
//           ),
//         ],
//       ),
//     );
//   }
// }
