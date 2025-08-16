import 'package:movies_app_clean/core/network/errors_message_model.dart';

class ServerException implements Exception {
  final ErrorsMessageModel errorsMessageModel;

  const ServerException({required this.errorsMessageModel});
}