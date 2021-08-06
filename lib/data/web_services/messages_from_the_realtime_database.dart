import 'package:dio/dio.dart';
import 'package:islamic_chat_app/constants/strings/strings.dart';

class MessagesFromTheDatabase {
  final String messageKey;
  late Dio dio;
  MessagesFromTheDatabase({required this.messageKey}) {
    BaseOptions baseOptions = new BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 30 * 1000,
      receiveTimeout: 30 * 1000,
    );
    dio = new Dio(baseOptions);
  }

  Future<Map<String, dynamic>> getAllMessages() async {
    try {
      Response response = await dio.get('${messageKey}.json');
      return response.data;
    } catch (e) {
      return {};
    }
  }
}
