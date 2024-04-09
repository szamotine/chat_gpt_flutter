import 'package:chat_gpt/data/asset_manager.dart';
import 'package:chat_gpt/data/chat_model.dart';
import 'package:chat_gpt/data/constants.dart';
import 'package:chat_gpt/domain/api_services/openai_api.dart';
import 'package:chat_gpt/domain/providers/models_provider.dart';
import 'package:chat_gpt/domain/show_modal.dart';
import 'package:chat_gpt/feature/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late bool _isTyping = false;
  late TextEditingController textEditingController;
  static const TextStyle chatTextStyle = TextStyle(color: Colors.white, fontSize: 20);
  late List<ChatModel> chatList = [ChatModel(message: 'Welcome to ChatGpt', chatIndex: 1)];
  late FocusNode focusNode;
  late ScrollController chatListScrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    chatListScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    chatListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelsProvider modelsProvider = Provider.of<ModelsProvider>(context, listen: false);

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
              await ShowModal.showModalSheet(context: context, provider: modelsProvider);
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
                controller: chatListScrollController,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatList[index].message, // chatMessages[index]['msg'].toString(),
                    chatIndex: chatList[index].chatIndex, //int.parse(chatMessages[index]['chatIndex'].toString()),
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
                        focusNode: focusNode,
                        style: chatTextStyle,
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you?",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 25),
                        ),
                        onSubmitted: (value) async {
                          await sendMessage(modelsProvider: modelsProvider);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () async {
                        await sendMessage(modelsProvider: modelsProvider);
                        scrollChatListToEnd();
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

  Future<void> sendMessage({required ModelsProvider modelsProvider}) async {
    final input = textEditingController.text;
    setState(() {
      textEditingController.clear();
      _isTyping = true;
      chatList.add(ChatModel(message: input, chatIndex: 0));
      scrollChatListToEnd();
      focusNode.unfocus();
    });

    var chatItem = await OpenAiAPI.sendTextRequest(input: input, model: "");

    debugPrint(chatItem.message);
    chatList.add(chatItem);
    setState(() {
      _isTyping = false;
      scrollChatListToEnd();
    });
  }

  void scrollChatListToEnd() {
    chatListScrollController.animateTo(
      chatListScrollController.position.maxScrollExtent + 40,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
  }
}
