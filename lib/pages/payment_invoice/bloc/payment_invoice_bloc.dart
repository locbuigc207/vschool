import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vschool/commons/models/payment_channel/payment_channel_model.dart';
import 'package:vschool/commons/models/payment_setting/payment_setting_model.dart';
import 'package:vschool/commons/models/qrCode/qr_code_model.dart';
import 'package:vschool/commons/repository/payment_method_repository.dart';
import 'package:vschool/commons/services/local_file_service/local_file_service.dart';
import 'package:http/http.dart' as http;

part 'payment_invoice_event.dart';
part 'payment_invoice_state.dart';

class PaymentInvoiceBloc
    extends Bloc<PaymentInvoiceEvent, PaymentInvoiceState> {
  final IPaymentMethodRepository _paymentMethodRepository;
  final ILocalFileService _localFileService;

  // ignore: unused_element
  FutureOr<void> _onCreateMomoPayment(
      CreateMomoPayment event, Emitter<PaymentInvoiceState> emit) async {
    emit(MomoPaymentLoading());

    try {
      final response = await http.post(
        Uri.parse('https://test-payment.momo.vn/v2/gateway/api/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "partnerCode": event.partnerCode,
          "requestId": event.requestId,
          "amount": event.amount,
          "orderId": event.orderId,
          "orderInfo": event.orderInfo,
          "redirectUrl": event.redirectUrl,
          "ipnUrl": event.ipnUrl,
          "requestType": event.requestType,
          "extraData": event.extraData,
          "lang": event.lang,
          "signature": event.signature,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["resultCode"] == 0) {
          emit(MomoPaymentSuccess(
            payUrl: responseData["payUrl"],
            shortLink: responseData["shortLink"],
          ));
        } else {
          emit(MomoPaymentFailure(
              error: responseData["message"] ?? "Unknown error"));
        }
      } else {
        emit(const MomoPaymentFailure(error: "Failed to create payment"));
      }
    } catch (e) {
      emit(MomoPaymentFailure(error: e.toString()));
    }
  }

  PaymentInvoiceBloc({
    required IPaymentMethodRepository paymentMethodRepository,
    required ILocalFileService localFileService,
  })  : _paymentMethodRepository = paymentMethodRepository,
        _localFileService = localFileService,
        super(PaymentMethodFetching()) {
    on<FetchPaymentSetting>(_onFetchPaymentSetting);
    on<PaymentMethodFetch>(_onPaymentMethodFetch);
    on<QrCodeGenerating>(_onQrCodeGenerating);
    on<QrCodeDownloaded>(_onQrCodeDownloaded);
  }

  FutureOr<void> _onFetchPaymentSetting(
    FetchPaymentSetting event,
    Emitter<PaymentInvoiceState> emit,
  ) async {
    emit(PaymentSettingLoading());
    final result = await _paymentMethodRepository.getPaymentSetting(
      studentId: event.studentId,
    );

    result.when(
      success: (paymentSetting) =>
          emit(PaymentSettingSuccess(paymentSetting: paymentSetting)),
      failure: (failure) => emit(PaymentSettingFailure(
          error: failure.message ?? 'Failed to fetch payment settings')),
    );
  }

  FutureOr<void> _onPaymentMethodFetch(
    PaymentMethodFetch event,
    Emitter<PaymentInvoiceState> emit,
  ) async {
    print('PaymentInvoiceBloc - Starting PaymentMethodFetch...');
    emit(PaymentMethodFetching());
    final result = await _paymentMethodRepository.getAllPaymentChannel();
    print('PaymentInvoiceBloc - API result: $result');

    result.when(
      success: (paymentChannels) {
        print(
            'PaymentInvoiceBloc - Success: ${paymentChannels.data?.length ?? 0} payment channels');
        emit(PaymentMethodFetchSuccess(lstPaymentMethod: paymentChannels.data));
      },
      failure: (failure) {
        print('PaymentInvoiceBloc - Failure: ${failure.message}');
        emit(PaymentMethodFetchFailure(
            mess: failure.message ?? 'Failed to fetch payment methods'));
      },
    );
  }

  FutureOr<void> _onQrCodeGenerating(
      QrCodeGenerating event, Emitter<PaymentInvoiceState> emit) async {
    emit(GenQrCodeInitial());

    final request = QrCodeGenerateRequest(
        studentId: event.studentId, listInvoiceIds: event.lstInvoice);

    final result = await _paymentMethodRepository.genQrCode(request: request);

    result.when(
      success: (success) =>
          emit(GenQrCodeSuccess(qrData: result.success!.info ?? '')),
      failure: (failure) =>
          emit(GenQrCodeFailure(mess: result.failure?.message ?? '')),
    );
  }

  FutureOr<void> _onQrCodeDownloaded(
      QrCodeDownloaded event, Emitter<PaymentInvoiceState> emit) async {
    print('PaymentInvoiceBloc - Starting QR code download...');
    emit(QrCodeDownloadedLoading());

    final saveFileResult = await _localFileService.saveFile(
      data: event.qrData,
      fileName: 'qr-code-${DateTime.now().millisecondsSinceEpoch}',
      directory: 'VSchool',
      fileExtension: 'jpg',
    );

    saveFileResult.when(
      success: (file) {
        print('PaymentInvoiceBloc - QR code saved successfully: ${file.path}');
        emit(QrCodeDownloadedSuccess(file: file, filePath: file.path));
      },
      failure: (failure) {
        print('PaymentInvoiceBloc - QR code save failed: ${failure.message}');
        emit(QrCodeDownloadedFailure(
            mess: failure.message ?? 'Có lỗi xảy ra khi lưu file'));
      },
    );
  }
}
