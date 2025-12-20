import 'package:json_annotation/json_annotation.dart';

part 'payment_setting_model.g.dart';

@JsonSerializable()
class PaymentSettingModel {
  final int? id;
  final int? schoolId;
  final String? masterMerchant;
  final String? merchantCode;
  final String? merchantCc;
  final String? merchantName;
  final String? ccy;
  final String? merchantCity;
  final String? countryCode;
  final String? terminalId;
  final String? storeId;
  final String? partnerCodeMomo;
  final String? accessKeyMomo;
  final String? secretKeyMomo;

  PaymentSettingModel({
    this.id,
    this.schoolId,
    this.masterMerchant,
    this.merchantCode,
    this.merchantCc,
    this.merchantName,
    this.ccy,
    this.merchantCity,
    this.countryCode,
    this.terminalId,
    this.storeId,
    this.partnerCodeMomo,
    this.accessKeyMomo,
    this.secretKeyMomo,
  });

  factory PaymentSettingModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentSettingModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentSettingModelToJson(this);
}
