import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_gpt/data/asset_manager.dart';
import 'package:chat_gpt/data/constants.dart';
import 'package:chat_gpt/feature/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.message, required this.chatIndex});

  final String message;
  final int chatIndex;

  static const TextStyle chatMessageTextStyle = TextStyle(color: Colors.white, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? kScaffoldBackgroundColor : kCardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? AssetsManager.personImagePath : AssetsManager.openaiLogoImagePath,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(label: message)
                      : DefaultTextStyle(
                          style: chatMessageTextStyle,
                          child: AnimatedTextKit(
                            displayFullTextOnTap: true,
                            isRepeatingAnimation: false,
                            totalRepeatCount: 0,
                            animatedTexts: [
                              TyperAnimatedText(
                                message.trim(),
                                speed: const Duration(milliseconds: 10),
                              )
                            ],
                          ),
                        ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 5),
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
