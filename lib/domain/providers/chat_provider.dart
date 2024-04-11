import 'package:chat_gpt/data/chat_model.dart';
import 'package:chat_gpt/domain/api_services/openai_api.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatModel> _chatList = [ChatModel(message: 'Welcome to Chat GPT', chatIndex: 1)];

  List<ChatModel> get getChatList => _chatList;

  void addChat({required ChatModel chatModel}) {
    _chatList.add(chatModel);
    notifyListeners();
  }

  Future<void> sendMessageAndReceiveAnswer({required String input, String? model}) async {
    try {
      var response = await OpenAiAPI.sendTextRequest(input: input, model: model);
      _chatList.add(response);
    } catch (error) {
      _chatList.add(ChatModel(message: 'Sorry, an error occurred: ${error.toString()}', chatIndex: 1));
    }

    notifyListeners();
  }
}
