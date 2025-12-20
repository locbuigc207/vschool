import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indexed/indexed.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/models/qrCode/qr_code_model.dart';
import 'package:vschool/commons/repository/payment_method_repository.dart';
import 'package:vschool/commons/services/local_file_service/local_file_service.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/modal/success_dialog.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/notification/widget/notification_shimmer_loading.dart';
import 'package:vschool/pages/payment_invoice/bloc/payment_invoice_bloc.dart';

@RoutePage()
class PaymentByQRCodePage extends StatefulWidget {
  final List<InvoiceInfoModel> lstInvoice;
  final ChildrenInfoModel child;

  const PaymentByQRCodePage(
      {Key? key, required this.lstInvoice, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentByQRCodePageState();
}

class _PaymentByQRCodePageState extends State<PaymentByQRCodePage> {
  String qrData = '';

  QrCodeGenerateRequest lstInvoiceId =
      QrCodeGenerateRequest(listInvoiceIds: [], studentId: 0);

  int totalAmount = 0;

  var tmp = '';

  @override
  void initState() {
    for (int i = 0; i < widget.lstInvoice.length; i++) {
      totalAmount += widget.lstInvoice[i].cost ?? 0;
      lstInvoiceId.listInvoiceIds
          ?.add(widget.lstInvoice[i].studentInvoiceId ?? 0);
    }
    tmp = jsonEncode(lstInvoiceId.listInvoiceIds ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentInvoiceBloc(
          paymentMethodRepository: getIt<IPaymentMethodRepository>(),
          localFileService: getIt<ILocalFileService>())
        ..add(QrCodeGenerating(
            studentId: widget.child.studentId!,
            lstInvoice: lstInvoiceId.listInvoiceIds ?? [])),
      child: BlocConsumer<PaymentInvoiceBloc, PaymentInvoiceState>(
        listener: (context, state) {
          if (state is GenQrCodeInitial) {
            context.loaderOverlay.show();
          } else if (state is GenQrCodeFailure) {
            context.loaderOverlay.hide();
            showErrorSnackBBar(context: context, message: state.mess);
          } else if (state is GenQrCodeSuccess) {
            context.loaderOverlay.hide();
          } else if (state is QrCodeDownloadedLoading) {
            context.loaderOverlay.show();
          } else if (state is QrCodeDownloadedFailure) {
            context.loaderOverlay.hide();
            showErrorSnackBBar(context: context, message: state.mess);
          } else if (state is QrCodeDownloadedSuccess) {
            context.loaderOverlay.hide();
            showDialog(
              context: context,
              builder: (contextDialog) {
                return SuccessDialog(
                  content: Platform.isIOS
                      ? 'Tải xuống QR Code thành công!\nFile đã được lưu vào thư mục Documents của ứng dụng.'
                      : 'Tải xuống QR Code thành công!\nFile đã được lưu vào thư viện ảnh.',
                  onButtonTap: () {
                    Navigator.of(contextDialog).pop(); // Đóng dialog
                    Navigator.of(context).pop(); // Quay về màn hình trước
                  },
                );
              },
            );
          }
        },
        builder: (context, state) {
          // Lấy qrData từ state
          String currentQrData = '';
          if (state is GenQrCodeSuccess) {
            currentQrData = state.qrData;
          }

          return currentQrData.isEmpty || currentQrData == ''
              ? Container(
                  color: Colors.white,
                  child: const NotificationShimmerLoading())
              : Scaffold(
                  body: Stack(
                    children: [
                      FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: ColorName.backgroundBottomSheet,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.w, 50.h, 30.w, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.cancel_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 80.w),
                                    Assets.images.logoNoName.image(width: 90.w),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Indexer(
                                    children: [
                                      Indexed(
                                        index: 3,
                                        child: SizedBox(
                                            width: 375.w,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50.0),
                                              child: Image.memory(
                                                base64Decode(currentQrData),
                                                fit: BoxFit.contain,
                                              ),
                                            )),
                                      ),
                                      Indexed(
                                        index: 1,
                                        child: Positioned(
                                          right: -10,
                                          child: Assets.icons.paintTable.svg(),
                                        ),
                                      ),
                                      Indexed(
                                        index: 2,
                                        child: Positioned(
                                          top: 120.h,
                                          left: -10.w,
                                          child: Assets.icons.clock.svg(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Xem lại chi tiết giao dịch',
                                      style:
                                          TextStyle(color: ColorName.linkBlue),
                                    ),
                                    Assets.icons.billBlue.svg(),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Assets.icons.studentBus.svg(width: 200.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 40,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            child: IconButton(
                              icon: Assets.icons.download.svg(),
                              onPressed: () {
                                context.read<PaymentInvoiceBloc>().add(
                                    QrCodeDownloaded(qrData: currentQrData));
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
