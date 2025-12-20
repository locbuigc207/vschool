import 'package:json_annotation/json_annotation.dart';

part 'message_data.g.dart';

@JsonSerializable()
class MessageData {
  final String? message;
  final int? resultCode;

  const MessageData({
    this.message,
    this.resultCode,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);
}
