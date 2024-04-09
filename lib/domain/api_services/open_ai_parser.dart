import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/data/chat_gpt_model_response.dart';
import 'package:chat_gpt/data/chat_gpt_response.dart';
import 'package:http/http.dart';

import 'open_ai_api_errors.dart';

class OpenAiParser {
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
    String message = '';
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (OpenAiAPIErrors.containsError(jsonResponse)) {
      throw HttpException(jsonResponse['error']['message']);
    }

    if (jsonResponse["choices"].length > 0) {
      var parsedResponse = ChatGptResponse.fromJson(jsonResponse);

      var choices = parsedResponse.choices;

      message = choices[0].message.content;
    } else {
      throw const HttpException("json response does not contain content");
    }

    return message;
  }
}
