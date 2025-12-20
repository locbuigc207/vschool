import 'package:json_annotation/json_annotation.dart';

part 'payment_channel_model.g.dart';

@JsonSerializable()
class PaymentChannelInfoModel {
  final int? id;
  final String? code;
  final String? name;
  final String? bankIcon;
  final String? description;
  final String? androidStoreId;
  final String? iosStoreId;

  PaymentChannelInfoModel({
    this.id,
    this.code,
    this.name,
    this.bankIcon,
    this.description,
    this.androidStoreId,
    this.iosStoreId,
  });

  factory PaymentChannelInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentChannelInfoModelFromJson(json);
}

@JsonSerializable()
class PaymentChannelResponse {
  final int? resultCode;
  final String? message;
  @JsonKey(name: 'data')
  final List<PaymentChannelInfoModel>? data;

  PaymentChannelResponse({
    this.resultCode,
    this.message,
    this.data,
  });

  factory PaymentChannelResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentChannelResponseFromJson(json);
}
