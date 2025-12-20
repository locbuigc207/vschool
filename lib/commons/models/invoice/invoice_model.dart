import 'package:json_annotation/json_annotation.dart';

part 'invoice_model.g.dart';

@JsonSerializable()
class InvoiceInfoModel {
  final int? studentInvoiceId;
  final int? studentId;
  final int? feeTypeId;
  final String? content;
  final int? cost;
  final int? status;
  // final String qrUrl;
  final int? paymentDate;
  final String? schoolMst;
  final String? invoidId;
  final String? billId;
  final String? description;

  InvoiceInfoModel({
    this.studentInvoiceId,
    this.studentId,
    this.feeTypeId,
    this.content,
    this.cost,
    this.status,
    // required this.qrUrl,
    this.paymentDate,
    this.schoolMst,
    this.invoidId,
    this.billId,
    this.description,
  });

  factory InvoiceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceInfoModelFromJson(json);
}

@JsonSerializable()
class InvoiceDataResponse {
  final int code;
  final String msg;
  @JsonKey(name: 'info')
  final List<InvoiceInfoModel>? newStudentInvoice;

  InvoiceDataResponse(
      {required this.code, required this.msg, this.newStudentInvoice});

  factory InvoiceDataResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDataResponseFromJson(json);
}
