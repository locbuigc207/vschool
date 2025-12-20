part of 'payment_invoice_bloc.dart';

abstract class PaymentInvoiceState extends Equatable {
  const PaymentInvoiceState();
}

class PaymentMethodFetching extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class MomoPaymentInitial extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class MomoPaymentLoading extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class MomoPaymentSuccess extends PaymentInvoiceState {
  final String payUrl;
  final String shortLink;

  const MomoPaymentSuccess({required this.payUrl, required this.shortLink});

  @override
  List<Object?> get props => [payUrl, shortLink];
}

class MomoPaymentFailure extends PaymentInvoiceState {
  final String error;

  const MomoPaymentFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class PaymentMethodFetchSuccess extends PaymentInvoiceState {
  final List<PaymentChannelInfoModel>? lstPaymentMethod;

  const PaymentMethodFetchSuccess({this.lstPaymentMethod});

  @override
  List<Object?> get props => [lstPaymentMethod];
}

class PaymentMethodFetchFailure extends PaymentInvoiceState {
  final String mess;

  const PaymentMethodFetchFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class GenQrCodeInitial extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class GenQrCodeSuccess extends PaymentInvoiceState {
  final String qrData;

  const GenQrCodeSuccess({required this.qrData});

  @override
  List<Object?> get props => [qrData];
}

class GenQrCodeFailure extends PaymentInvoiceState {
  final String mess;

  const GenQrCodeFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class QrCodeDownloadedLoading extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class QrCodeDownloadedSuccess extends PaymentInvoiceState {
  final File file;
  final String filePath;

  const QrCodeDownloadedSuccess({required this.file, required this.filePath});

  @override
  List<Object?> get props => [file];
}

class QrCodeDownloadedFailure extends PaymentInvoiceState {
  final String mess;

  const QrCodeDownloadedFailure({required this.mess});

  @override
  List<Object?> get props => [mess];
}

class PaymentSettingInitial extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class PaymentSettingLoading extends PaymentInvoiceState {
  @override
  List<Object?> get props => [];
}

class PaymentSettingSuccess extends PaymentInvoiceState {
  final PaymentSettingModel paymentSetting;

  const PaymentSettingSuccess({required this.paymentSetting});

  @override
  List<Object?> get props => [paymentSetting];
}

class PaymentSettingFailure extends PaymentInvoiceState {
  final String error;

  const PaymentSettingFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
