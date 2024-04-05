import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:chat_gpt/data/chat_gpt_model_response.dart';
import 'package:chat_gpt/data/env.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Class that handles all API calls to OpenAI
class OpenAiAPI {
  static const className = "OpenAiAPI";
  static const baseUrl = 'api.openai.com';
  static const version = '/v1/models';

  /// Retrieves available models from OpenAI
  static Future<List<String>> getModels() async {
    List<String> modelList = [];

    try {
      String openAIApiKey = Env.myApiKey;
      String header1 = "Authorization";
      String header1Key = 'Bearer $openAIApiKey';

      var url = Uri.https(baseUrl, version);

      var response = await http.get(url, headers: {header1: header1Key});
      modelList = parseModelResponse(response);
    } catch (error) {
      developer.log('Error in $className: ${error.toString()}');
    }
    return modelList;
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
}

/// Class that handles potential errors from API communicating with OpenAi services.
class OpenAiAPIErrors {
  static const List<String> errorList = ['error'];

  static bool containsError(Map<String, dynamic> jsonResponse) {
    if (jsonResponse['error'] != null) {
      return true;
    }
    return false;
  }
}
