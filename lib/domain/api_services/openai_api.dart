import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/data/chat_gpt_model_response.dart';
import 'package:chat_gpt/data/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// Class that handles all API calls to OpenAI
class OpenAiAPI {
  static const className = "OpenAiAPI";
  static const baseUrl = 'api.openai.com';
  static const version = '/v1/models';
  static List<String> models = [];

  /// Retrieves available models from OpenAI
  static Future<void> getModels() async {
    try {
      String openAIApiKey = Env.myApiKey;
      String header1 = "Authorization";
      String header1Key = 'Bearer $openAIApiKey';

      var url = Uri.https(baseUrl, version);

      var response = await http.get(url, headers: {header1: header1Key});

      parseModelResponse(response);
    } catch (error) {
      debugPrint('Error in $className: ${error.toString()}');
    }
  }

  static void printModels() {
    for (var item in models) {
      debugPrint(item);
    }
  }

  static void parseModelResponse(Response response) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (OpenAiAPIErrors.containsError(jsonResponse)) {
      throw HttpException(jsonResponse['error']['message']);
    }

    var parsedResponse = ChatGptModelResponse.fromJson(jsonResponse);

    models = parsedResponse.extractModelList();

    printModels();
  }
}

class OpenAiAPIErrors {
  static const List<String> errorList = ['error'];

  static bool containsError(Map<String, dynamic> jsonResponse) {
    if (jsonResponse['error'] != null) {
      return true;
    }
    return false;
  }
}