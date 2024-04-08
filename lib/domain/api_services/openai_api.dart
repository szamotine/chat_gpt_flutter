import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/data/chat_gpt_model_response.dart';
import 'package:chat_gpt/data/chat_gpt_response.dart';
import 'package:chat_gpt/data/env.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'open_ai_api_errors.dart';
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
      modelList = parseModelResponse(response);
    } catch (error) {
      OpenAiAPIHelper.logError(className, error.toString());
    }
    return modelList;
  }

  static Future<void> sendTextRequest({
    required String input,
    String? model,
  }) async {
    try {
      var url = OpenAiAPIHelper.getUrl(completionsUrl);

      var body = jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": "What is flutter?",
            }
          ],
          "max_tokens": 20,
        },
      );

      var response = await http.post(url,
          headers: {
            authorizationHeader: authorizationHeaderKey,
            contentHeader: contentHeaderKey,
          },
          body: body);
      parseTextResponse(response);
    } catch (error) {
      OpenAiAPIHelper.logError(className, error.toString());
    }
  }

  /// Converts http response to ChatGptModelResponse.
  static List<String> parseModelResponse(Response response) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (OpenAiAPIErrors.containsError(jsonResponse)) {
      throw HttpException(jsonResponse['error']['message']);
    }

    var parsedResponse = ChatGptModelResponse.fromJson(jsonResponse);

    return parsedResponse.extractModelList();
  }

  static String parseTextResponse(Response response) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (OpenAiAPIErrors.containsError(jsonResponse)) {
      throw HttpException(jsonResponse['error']['message']);
    }

    var parsedResponse = ChatGptResponse.fromJson(jsonResponse);

    var choices = parsedResponse.choices;

    var message = choices[0].message.content;

    return message;
  }
}
