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
