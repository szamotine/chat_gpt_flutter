import 'package:chat_gpt/domain/api_services/openai_api.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<String>> getAllModels() async {
    return await OpenAiAPI.getModels();
  }
}
