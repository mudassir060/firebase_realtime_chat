// class ChatMember {
//   const ChatMember({
//     required this.displayName,
//     required this.userSince,
//     required this.profile,
//     required this.username,
//     required this.userId,
//     required this.read,
//   });

//   final bool read;
//   final String username;
//   final String displayName;
//   final String userId;
//   final DateTime userSince;
//   final String profile;

//   ChatMember.fromJson(Map<String, dynamic> json)
//       : read = json['read'],
//         username = json['username'],
//         displayName = json['displayName'],
//         userId = json['userId'],
//         userSince = DateTime.parse(json['userSince']),
//         profile = json['profile'];

//   Map<String, dynamic> toJson() => {
//         'read': read,
//         'username': username,
//         'displayName': displayName,
//         'userId': userId,
//         'userSince': userSince.toIso8601String(),
//         'profile': profile,
//       };
// }
