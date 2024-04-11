import 'dart:convert';

import 'package:chat_gpt/data/chat_model.dart';
import 'package:chat_gpt/data/env.dart';
import 'package:chat_gpt/domain/api_services/open_ai_parser.dart';
import 'package:http/http.dart' as http;

import 'open_ai_api_helper.dart';

/// Class that handles all API calls to OpenAI
class OpenAiAPI {
  /// API key to use OpenAI service
  static String openAIApiKey = Env.myApiKey;

  /// class name for logging purposes
  static const className = "OpenAiAPI";

  /// url for retrieving model list
  static const modelUrl = '/v1/models';

  /// url for sending generative request
  static const completionsUrl = 'v1/chat/completions';

  static const String authorizationHeader = "Authorization";

  /// authorization header for openAi requests
  static String authorizationHeaderKey = 'Bearer $openAIApiKey';

  static const contentHeader = "Content-Type";
  static const contentHeaderKey = "application/json";

  /// Retrieves available models from OpenAI
  static Future<List<String>> getModels() async {
    List<String> modelList = [];

    try {
      var url = OpenAiAPIHelper.getUrl(modelUrl);

      var response = await http.get(url, headers: {authorizationHeader: authorizationHeaderKey});
      modelList = OpenAiParser.parseModelResponse(response);
    } catch (error) {
      OpenAiAPIHelper.logError(className, error.toString());
    }
    return modelList;
  }

  static Future<ChatModel> sendTextRequest({required String input, String? model}) async {
    ChatModel chatResponse = ChatModel(message: '', chatIndex: 1);
    try {
      var url = OpenAiAPIHelper.getUrl(completionsUrl);

      var body = jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": input,
            }
          ],
          //"max_tokens": 20,
        },
      );

      var response = await http.post(url,
          headers: {
            authorizationHeader: authorizationHeaderKey,
            contentHeader: contentHeaderKey,
          },
          body: body);
      chatResponse = OpenAiParser.parseTextResponse(response);
    } catch (error) {
      OpenAiAPIHelper.logError(className, error.toString());
    }

    return chatResponse;
  }
}
