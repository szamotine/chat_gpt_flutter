import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '../chat_gpt/secret.env') //Path of your secret.env file
abstract class Env {
  @EnviedField(varName: 'OPENAI_API_KEY', obfuscate: true)
  static final String myApiKey = _Env.myApiKey;
}
