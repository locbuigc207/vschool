import 'package:json_annotation/json_annotation.dart';
import 'package:vschool/commons/models/message_data/message_data.dart';

part 'no_data.g.dart';

@JsonSerializable()
class NoData {
  final MessageData? mess;

  NoData({
    required this.mess,
  });

  factory NoData.fromJson(Map<String, dynamic> json) => _$NoDataFromJson(json);
}
