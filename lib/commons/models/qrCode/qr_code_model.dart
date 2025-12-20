import 'package:json_annotation/json_annotation.dart';

part 'qr_code_model.g.dart';

@JsonSerializable()
class QrCodeGenerateRequest {
  final int? studentId;
  final List<int>? listInvoiceIds;

  QrCodeGenerateRequest({this.studentId, this.listInvoiceIds});

  factory QrCodeGenerateRequest.fromJson(Map<String, dynamic> json) =>
      _$QrCodeGenerateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QrCodeGenerateRequestToJson(this);
}

@JsonSerializable()
class QrCodeResponse {
  final int code;
  final String msg;
  final String? info;

  QrCodeResponse({
    required this.code,
    required this.msg,
    this.info,
  });

  factory QrCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$QrCodeResponseFromJson(json);
}
