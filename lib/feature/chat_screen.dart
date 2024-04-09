import 'package:chat_gpt/data/asset_manager.dart';
import 'package:chat_gpt/data/constants.dart';
import 'package:chat_gpt/domain/api_services/openai_api.dart';
import 'package:chat_gpt/domain/show_modal.dart';
import 'package:chat_gpt/feature/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late bool _isTyping = false;
  late TextEditingController textEditingController;
  static const TextStyle chatTextStyle = TextStyle(color: Colors.white, fontSize: 20);

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: const Text(
          "ChatGPT",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogoImagePath),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ShowModal.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_horiz_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatMessages[index]['msg'].toString(),
                    chatIndex: int.parse(chatMessages[index]['chatIndex'].toString()),
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 20,
            ),
            Material(
              color: kCardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: chatTextStyle,
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you?",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
                        ),
                        // onSubmitted: (value) {
                        //   /// TODO: function to send message
                        // },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () async {
                        setState(() {
                          _isTyping = true;
                        });
                        await OpenAiAPI.sendTextRequest(input: textEditingController.text, model: "");
                        setState(() {
                          _isTyping = false;
                          textEditingController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
