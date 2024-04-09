import 'package:chat_gpt/data/asset_manager.dart';
import 'package:chat_gpt/data/chat_model.dart';
import 'package:chat_gpt/data/constants.dart';
import 'package:chat_gpt/domain/api_services/openai_api.dart';
import 'package:chat_gpt/domain/providers/chat_provider.dart';
import 'package:chat_gpt/domain/providers/models_provider.dart';
import 'package:chat_gpt/domain/show_modal.dart';
import 'package:chat_gpt/feature/widgets/chat_widget.dart';
import 'package:chat_gpt/feature/widgets/text_widget.dart';
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
  // late List<ChatModel> chatList = [ChatModel(message: 'Welcome to ChatGpt', chatIndex: 1)];
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
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

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
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatProvider.getChatList[index].message, // chatMessages[index]['msg'].toString(),
                    chatIndex: chatProvider.getChatList[index].chatIndex, //int.parse(chatMessages[index]['chatIndex'].toString()),
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
                          await sendMessage(chatProvider: chatProvider, modelsProvider: modelsProvider);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () async {
                        await sendMessage(chatProvider: chatProvider, modelsProvider: modelsProvider);
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

  Future<void> sendMessage({required ChatProvider chatProvider, required ModelsProvider modelsProvider}) async {
    final input = textEditingController.text;

    if (input.length > 1) {
      setState(() {
        textEditingController.clear();
        _isTyping = true;
        chatProvider.addChat(chatModel: ChatModel(message: input, chatIndex: 0));
        focusNode.unfocus();
      });

      var chatItem = await OpenAiAPI.sendTextRequest(input: input, model: modelsProvider.getCurrentModel);

      debugPrint(chatItem.message);
      chatProvider.addChat(chatModel: chatItem);
      setState(() {
        _isTyping = false;
      });
      scrollChatListToEnd();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          padding: EdgeInsets.all(30.0),
          backgroundColor: Colors.white,
          content: Center(
            child: TextWidget(
              color: Colors.red,
              label: 'Please enter text',
            ),
          )));
    }
  }

  void scrollChatListToEnd() {
    setState(() {
      chatListScrollController.animateTo(
        chatListScrollController.position.maxScrollExtent + 40,
        duration: const Duration(seconds: 1),
        curve: Curves.linear,
      );
    });
  }
}
