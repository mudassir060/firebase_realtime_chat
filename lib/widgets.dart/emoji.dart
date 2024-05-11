import 'package:firebase_realtime_chat/common/emojis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmojiKeyboard extends StatefulWidget {
  final Function(String) onSelecte;

  const EmojiKeyboard({super.key, required this.onSelecte});

  @override
  _EmojiKeyboardState createState() => _EmojiKeyboardState();
}

class _EmojiKeyboardState extends State<EmojiKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 8,
            children: emojis.map((emoji) {
              return GestureDetector(
                onTap: () {
                  widget.onSelecte('https://fonts.gstatic.com/s/e/notoemoji/latest/$emoji/lottie.json');
                },
                child: Center(
                  child: Lottie.network(
                      'https://fonts.gstatic.com/s/e/notoemoji/latest/$emoji/lottie.json'),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
