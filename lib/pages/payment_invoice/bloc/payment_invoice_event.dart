part of 'payment_invoice_bloc.dart';

abstract class PaymentInvoiceEvent extends Equatable {
  const PaymentInvoiceEvent();
}

class FetchPaymentSetting extends PaymentInvoiceEvent {
  final int studentId;

  const FetchPaymentSetting({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}

class PaymentMethodFetch extends PaymentInvoiceEvent {
  @override
  List<Object?> get props => [];
}

class CreateMomoPayment extends PaymentInvoiceEvent {
  final String partnerCode;
  final String requestId;
  final int amount;
  final String orderId;
  final String orderInfo;
  final String redirectUrl;
  final String ipnUrl;
  final String requestType;
  final String extraData;
  final String lang;
  final String signature;

  const CreateMomoPayment({
    required this.partnerCode,
    required this.requestId,
    required this.amount,
    required this.orderId,
    required this.orderInfo,
    required this.redirectUrl,
    required this.ipnUrl,
    required this.requestType,
    required this.extraData,
    required this.lang,
    required this.signature,
  });

  @override
  List<Object> get props => [
        partnerCode,
        requestId,
        amount,
        orderId,
        orderInfo,
        redirectUrl,
        ipnUrl,
        requestType,
        extraData,
        lang,
        signature,
      ];
}

class QrCodeGenerating extends PaymentInvoiceEvent {
  final int studentId;
  final List<int> lstInvoice;

  const QrCodeGenerating({required this.studentId, required this.lstInvoice});

  @override
  List<Object?> get props => [];
}

class QrCodeDownloaded extends PaymentInvoiceEvent {
  final String qrData;

  const QrCodeDownloaded({required this.qrData});

  @override
  List<Object?> get props => [];
}
