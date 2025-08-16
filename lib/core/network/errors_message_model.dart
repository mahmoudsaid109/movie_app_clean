import 'package:equatable/equatable.dart';

class ErrorsMessageModel extends Equatable {
  final int statusCode;
  final String statusMessage;
  final bool success;

  const ErrorsMessageModel({
    required this.statusCode,
    required this.statusMessage,
    required this.success,
  });
  
  factory ErrorsMessageModel.fromJson(Map<String, dynamic> json) => ErrorsMessageModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    success: json["success"],
  );

  @override
  List<Object?> get props => [
    statusCode,
    statusMessage,
    success,
  ];
}
