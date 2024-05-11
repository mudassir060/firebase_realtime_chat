

### Overview:
This Flutter package provides an easy-to-use solution for integrating real-time chat functionality into your Flutter applications using Firebase Firestore. With this package, developers can create private and community chat rooms effortlessly with various customization options to suit their UI needs.

### Features:

- **Community Chat Room:** Allows users to participate in group conversations within a community.
- **Private Chat:** Enables users to engage in one-on-one private conversations.
- **Image Support:** Users can share images within chats.
- **Emoji Support:** Users can send emoji text messages.
- **Customizable UI:** Customize chat bubbles, text fields, and app bars to match your app's design.


#### Installation:
To use this package in your Flutter project, add it to your pubspec.yaml file:

    dependencies:
      firebase_realtime_chat: ^version_number
Then, run `flutter pub get` to install the package.

##### Usage:
###### Import the package in your Dart file:

    import 'package:firebase_realtime_chat/firebase_realtime_chat.dart';

### Private Chat:
    ChatView(
      userData: UserModel,
      iconColor: Colors.grey,
      textFieldBorderColor: Colors.blue,
      imageQuality: 25,
      defaultImage: "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
      appBar: AppBar,
      imageDownloadButton: false,
      ownerBubbleColor: Color.fromARGB(255, 199, 249, 245),
      otherBubbleColor: Color.fromARGB(255, 250, 236, 193),
    ),
#### Customization Options:
- **userData (required UserModel)::** The user data object representing the current user in the chat room.
- **textFieldBorderColor (Color):** Enable or disable the time picker.
- **defaultImage (String):** Default image URL to display for users without a profile picture.
- **appBar (AppBar):** Custom app bar to be displayed in the chat room.
- **iconColor (Color):** Color of icons within the chat room.
- **imageQuality (int):** Quality of images sent in the chat room (0 to 100).
- **imageDownloadButton (bool):** Whether to show a button for downloading images in the chat room.
- **ownerBubbleColor (Color):** Color of chat bubbles for messages sent by the current user.
- **otherBubbleColor (Color):** Color of chat bubbles for messages sent by other users.


### Chat Room:
    ChatRoomView(
      senderMember: UserModel,
      receiverMember: UserModel,
      smsText: String?,
      iconColor: Colors.grey,
      textFieldBorderColor: Colors.blue,
      imageQuality: 25,
      defaultImage: "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
      appBar: AppBar,
      imageDownloadButton: false,
      ownerBubbleColor: Color.fromARGB(255, 199, 249, 245),
      otherBubbleColor: Color.fromARGB(255, 250, 236, 193),
    )
#### Customization Options:
- **senderMember (required UserModel):** User data object representing the sender of the message.
- **receiverMember (required UserModel):** User data object representing the receiver of the message.
- **smsText (String?):** Optional initial message text to be displayed in the chat room.
- **textFieldBorderColor (Color):** Enable or disable the time picker.
- **defaultImage (String):** Default image URL to display for users without a profile picture.
- **appBar (AppBar):** Custom app bar to be displayed in the chat room.
- **iconColor (Color):** Color of icons within the chat room.
- **imageQuality (int):** Quality of images sent in the chat room (0 to 100).
- **imageDownloadButton (bool):** Whether to show a button for downloading images in the chat room.
- **ownerBubbleColor (Color):** Color of chat bubbles for messages sent by the current user.
- **otherBubbleColor (Color):** Color of chat bubbles for messages sent by other users.

### CommunityChatRoomView(
      userData: UserModel,
      textFieldBorderColor: Colors.blue,
      defaultImage: "https://github.com/mudassir060/firebase_realtime_chat/blob/main/assets/profile.jpeg?raw=true",
      appBar: AppBar,
      iconColor: Colors.grey,
      imageQuality: 25,
      imageDownloadButton: false,
      ownerBubbleColor: Color.fromARGB(255, 199, 249, 245),
      otherBubbleColor: Color.fromARGB(255, 250, 236, 193),
    )
#### Customization Options:
- **userData (required UserModel)::** The user data object representing the current user in the chat room.
- **textFieldBorderColor (Color):** Enable or disable the time picker.
- **defaultImage (String):** Default image URL to display for users without a profile picture.
- **appBar (AppBar):** Custom app bar to be displayed in the chat room.
- **iconColor (Color):** Color of icons within the chat room.
- **imageQuality (int):** Quality of images sent in the chat room (0 to 100).
- **imageDownloadButton (bool):** Whether to show a button for downloading images in the chat room.
- **ownerBubbleColor (Color):** Color of chat bubbles for messages sent by the current user.
- **otherBubbleColor (Color):** Color of chat bubbles for messages sent by other users.

### Sending Community Messages:
    // Sending a message with text
    sendCommunityMessage(
      messageText: "Hello, world!",
      userId: "user_id",
      name: "Name",
      profile: "Profile URL",
    );
    
    // Sending an image captured from the camera
    sentCommunityImage(
      userId: "user_id",
      name: "Name",
      profile: "Profile URL",
    );
    
    // Sending an image from file
    sentCommunityImageByFile(
      userId: "user_id",
      name: "Name",
      profile: "Profile URL",
      file: File("image_path"),
    );
    
### Contributing:
Contributions are welcome! Feel free to submit issues or pull requests on GitHub.

### License:
This package is licensed under the `GNU General Public License v3.0` License.

#### Author:
`Mudassir Mukhtar`

#### Contact:
 <a href="https://www.linkedin.com/in/mudassir-mukhtar-17aa89196/" target="_blank" rel="noopener noreferrer">
   <img src="https://img.shields.io/badge/LinkedIn-Profile-blue?logo=linkedin&logoColor=white&color=blue" />
 </a>
 <a href="mailto:mudassirmukhtar4@gmail.com" target="_blank" rel="noopener noreferrer">
   <img src="https://img.shields.io/badge/Gmail-Address-red?logo=gmail&logoColor=white&color=blue" />
 </a>
 <a href="https://wa.me/+923454335400" target="_blank" rel="noopener noreferrer">
   <img src="https://img.shields.io/badge/Whatsapp-Number-blue?logo=whatsapp&logoColor=white&color=blue" />
 </a>
  <a href="https://www.facebook.com/lovely06mian" target="_blank" rel="noopener noreferrer">
   <img src="https://img.shields.io/badge/Facebook-Profile-blue?logo=facebook&logoColor=white&color=blue" />
 </a>

##### Acknowledgments:
Thank you to the Flutter community for their contributions and support.

#### Support:
For any questions or assistance, please reach out to the author or open an issue on GitHub.

#### Disclaimer:
This package is provided as-is without any warranty. Use it at your own discretion.

# Happy Coding! 🚀
