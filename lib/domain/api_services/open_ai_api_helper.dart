import 'dart:developer' as developer;

class OpenAiAPIHelper {
  /// base url for open ai requests
  static const baseUrl = 'api.openai.com';

  static Uri getUrl(String path) {
    return Uri.https(baseUrl, path);
  }

  static void logError(String className, String error) {
    developer.log('Error in $className: $error');
  }
}
