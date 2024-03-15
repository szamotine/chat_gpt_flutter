import 'package:chat_gpt/data/asset_manager.dart';
import 'package:chat_gpt/data/constants.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: kCardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Image.asset(AssetsManager.personImagePath)],
            ),
          ),
        )
      ],
    );
  }
}
