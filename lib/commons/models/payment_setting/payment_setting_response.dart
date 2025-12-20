import 'package:json_annotation/json_annotation.dart';
import 'payment_setting_model.dart';

part 'payment_setting_response.g.dart';

@JsonSerializable()
class PaymentSettingResponse {
  final int code;
  final String msg;
  final PaymentSettingModel info;

  PaymentSettingResponse({
    required this.code,
    required this.msg,
    required this.info,
  });

  factory PaymentSettingResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentSettingResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentSettingResponseToJson(this);
}
