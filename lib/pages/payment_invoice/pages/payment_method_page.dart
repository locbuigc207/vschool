import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/extensions/number_ext.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/models/payment_setting/payment_setting_model.dart';
import 'package:vschool/commons/models/qrCode/qr_code_model.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/pages/payment_invoice/bloc/payment_invoice_bloc.dart';
import '../../../commons/services/deep_link_service.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/commons/repository/payment_method_repository.dart';
import 'package:vschool/commons/services/local_file_service/local_file_service.dart';
import 'package:vschool/commons/widgets/modal/alert_dialog.dart';

@RoutePage()
class PaymentMethodPage extends StatefulWidget {
  final List<InvoiceInfoModel> lstInvoice;
  final ChildrenInfoModel child;

  const PaymentMethodPage(
      {super.key, required this.child, required this.lstInvoice});

  @override
  State<StatefulWidget> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int totalAmount = 0;
  String billInfo = '';
  QrCodeGenerateRequest lstInvoiceId =
      QrCodeGenerateRequest(listInvoiceIds: [], studentId: 0);
  List<String?> lstBillIds = [];
  PaymentSettingModel? paymentSetting;

  var tmp = '';
  late StreamSubscription<Uri> _deepLinkSubscription;

  @override
  void initState() {
    for (int i = 0; i < widget.lstInvoice.length; i++) {
      totalAmount += widget.lstInvoice[i].cost ?? 0;
      if (i > 0 && i < widget.lstInvoice.length - 1) {
        billInfo += '${widget.lstInvoice[i].content ?? ''}, ';
      } else if (i == widget.lstInvoice.length - 1 &&
          widget.lstInvoice.length > 1) {
        billInfo += 'và ${widget.lstInvoice[i].content ?? ''}';
      } else {
        billInfo += widget.lstInvoice[i].content ?? '';
      }
      lstInvoiceId.listInvoiceIds
          ?.add(widget.lstInvoice[i].studentInvoiceId ?? 0);
      lstBillIds.add(widget.lstInvoice[i].billId);
    }
    billInfo = billInfo.toString().trim();
    tmp = jsonEncode(lstInvoiceId.listInvoiceIds ?? []);
    super.initState();
    _setupDeepLinkHandling();
    debugPrint("${widget.child.studentId!}");
  }

  void _setupDeepLinkHandling() {
    _deepLinkSubscription = DeepLinkService().deepLinkStream.listen((uri) {
      debugPrint('Payment callback received in PaymentMethodPage');
      debugPrint('URI: $uri');
      debugPrint('Query parameters: ${uri.queryParameters}');

      // Xử lý kết quả thanh toán
      final resultCode = uri.queryParameters['resultCode'];
      final message = uri.queryParameters['message'];

      if (resultCode == '0' || resultCode == '9000') {
        // Thanh toán thành công
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 10),
                Text(
                  "Thanh toán thành công",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mã giao dịch:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  uri.queryParameters['orderId'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Nội dung thanh toán:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  billInfo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Số tiền:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalAmount.formatCurrency(symbol: '₫'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Sarabun',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.router.popUntil(
                      (route) => route.settings.name == 'InvoiceDetailRoute');
                  // Refresh invoice list by popping back to InvoiceDetailRoute
                  // The InvoiceDetailRoute will handle the refresh
                },
                child: const Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Thanh toán thất bại
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.red, size: 28),
                SizedBox(width: 10),
                Text(
                  "Thanh toán thất bại",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Lỗi:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message ?? "Có lỗi xảy ra trong quá trình thanh toán",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Nội dung thanh toán:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  billInfo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Số tiền:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sarabun',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalAmount.formatCurrency(symbol: '₫'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Sarabun',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  "Đóng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _deepLinkSubscription.cancel();
    super.dispose();
  }

  final String dataImage =
      'https://img.vietqr.io/image/970407-19035102416014-compact2.png?amount=150000&addInfo=Tiền%20học%20kỳ%201&accountName=LA%20THANH%20HAI';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentInvoiceBloc(
        paymentMethodRepository: getIt<IPaymentMethodRepository>(),
        localFileService: getIt<ILocalFileService>(),
      )..add(FetchPaymentSetting(studentId: widget.child.studentId!)),
      child: BlocConsumer<PaymentInvoiceBloc, PaymentInvoiceState>(
        listener: (context, state) {
          debugPrint('PaymentInvoiceState: $state');
          if (state is PaymentSettingSuccess) {
            setState(() {
              paymentSetting = state.paymentSetting;
            });
          } else if (state is PaymentSettingFailure) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Lỗi"),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("Đóng"),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return BasePage(
            backgroundColor: Colors.white,
            title: 'Chọn phương thức thanh toán',
            child: Stack(
              children: [
                FadeAnimation(
                  delay: 0.5,
                  child: GradientHeaderContainer(height: 140.h),
                ),
                SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: FadeAnimation(
                      delay: 1,
                      direction: FadeDirection.up,
                      child: RoundedTopContainer(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(30.w, 24.h, 30.w, 32.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chi tiết giao dịch',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sarabun',
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: 76.w,
                                  height: 4.h,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24))),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    const Text(
                                      'Tên học sinh',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sarabun',
                                        color: ColorName.borderColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.child.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sarabun',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                const Divider(),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    const Text(
                                      'Số điện thoại',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sarabun',
                                        color: ColorName.borderColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.child.parentPhonenum ?? '',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Sarabun',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                const Divider(),
                                SizedBox(height: 10.h),
                                const Text(
                                  'Bao gồm',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Sarabun',
                                    color: ColorName.borderColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Column(
                                    children: [
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                Text(
                                                  widget.lstInvoice[index]
                                                          .content ??
                                                      '',
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Sarabun',
                                                    color:
                                                        ColorName.borderColor,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  (widget.lstInvoice[index]
                                                              .cost ??
                                                          0)
                                                      .formatCurrency(
                                                          symbol: '₫'),
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Sarabun',
                                                    color:
                                                        ColorName.borderColor,
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 8.h),
                                          itemCount: widget.lstInvoice.length),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                const Divider(),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    const Text(
                                      'Tổng',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Sarabun',
                                        color: ColorName.textGray3,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      totalAmount.formatCurrency(symbol: '₫'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 40.h),
                                const Text(
                                  'Phương thức thanh toán',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Sarabun',
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: 76.w,
                                  height: 4.h,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24))),
                                ),
                                SizedBox(height: 8.h),
                                // Ví MoMo - Đưa lên đầu
                                Container(
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: () {
                                        createMomoPayment(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: Colors.pink
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Assets
                                                  .icons.momoIconSquarePinkbg
                                                  .svg(height: 24, width: 24),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Ví MoMo',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    'Thanh toán nhanh chóng và tiện lợi',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Ngân hàng nội địa
                                Container(
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: () {
                                        //context.pushRoute(const PaymentByBankRoute());
                                        showFeatureUnderDevelopmentDialog(
                                            context,
                                            featureName: 'Ngân hàng nội địa');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Assets.icons.bank
                                                  .svg(height: 24, width: 24),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Ngân hàng nội địa',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    'Vietinbank, Techcombank, ...',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Thẻ Visa, Master Card
                                Container(
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.r),
                                      onTap: () {
                                        showFeatureUnderDevelopmentDialog(
                                            context,
                                            featureName:
                                                'Thẻ Visa, Master Card');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 12.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: Colors.purple
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Assets.icons.credirCard
                                                  .svg(height: 24, width: 24),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Thẻ Visa, Master Card',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    'Thẻ quốc tế Visa, Master Card',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    bottomSheet: Container(
                      decoration: const BoxDecoration(
                        color: ColorName.backgroundBottomSheet,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0)),
                      ),
                      height: 100.h,
                      child: Wrap(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10.h),
                                  BlocConsumer<PaymentInvoiceBloc,
                                      PaymentInvoiceState>(
                                    listener: (context, state) {
                                      if (state is GenQrCodeFailure) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(state.mess),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } else if (state is GenQrCodeSuccess) {
                                        context.pushRoute(PaymentByQRCodeRoute(
                                            lstInvoice: widget.lstInvoice,
                                            child: widget.child));
                                      }
                                    },
                                    builder: (context, state) {
                                      return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent
                                                .withValues(alpha: 0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<PaymentInvoiceBloc>()
                                                .add(QrCodeGenerating(
                                                    studentId:
                                                        widget.child.studentId!,
                                                    lstInvoice: lstInvoiceId
                                                            .listInvoiceIds ??
                                                        []));
                                          },
                                          child: Row(
                                            children: const [
                                              Text(
                                                "Lấy mã QR giao dịch",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Icon(Icons.keyboard_arrow_up),
                                            ],
                                          ));
                                    },
                                  ),
                                ],
                              ),
                              Assets.images.qrCode
                                  .image(width: 300.w, height: 300.h),
                            ],
                          ),
                        ],
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

  Future<void> createMomoPayment(BuildContext context) async {
    debugPrint("$paymentSetting");
    if (paymentSetting == null ||
        (paymentSetting?.partnerCodeMomo == null ||
            paymentSetting!.partnerCodeMomo!.isEmpty)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Cảnh báo"),
          content: RichText(
            text: TextSpan(
              style: Theme.of(ctx).textTheme.bodyMedium,
              children: const [
                TextSpan(
                  text: 'Chưa có thông tin thanh toán MoMo!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      '\nVui lòng chọn phương thức khác hoặc liên hệ nhà trường!',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Đóng"),
            ),
          ],
        ),
      );
      return;
    }

    const String endpoint = "https://payment.momo.vn/v2/gateway/api/create";
    //const String endpoint = "https://test-payment.momo.vn/v2/gateway/api/create";
    const String partnerCode = "MOMOFWJF20250228";
    final String subPartnerCode = paymentSetting!.partnerCodeMomo!;
    const String accessKey = "axrWueODKDtaKP8y";
    const String secretKey = "0RMJUGPnxvnuik8freiWVefaYGhKGkZe";

    var uuid = const Uuid();
    final String requestId = uuid.v4();
    final String orderId =
        "${lstBillIds.join('+')}_${DateTime.now().millisecondsSinceEpoch.toString()}";

    // Định nghĩa redirectUrl với scheme và path cụ thể
    const String redirectUrl = "vschool://payment/callback";
    const String ipnUrl =
        "https://api.v-school.vn/api/public/payment/momo/result";

    debugPrint('Creating MoMo payment request...');
    debugPrint('OrderId: $orderId');
    debugPrint('Amount: $totalAmount');
    debugPrint('Bill Info: $billInfo');
    debugPrint('Redirect URL: $redirectUrl');
    debugPrint('IPN URL: $ipnUrl');

    // Nội dung request
    final Map<String, dynamic> payload = {
      "partnerCode": partnerCode,
      "subPartnerCode": subPartnerCode,
      "accessKey": accessKey,
      "requestId": requestId,
      "amount": totalAmount,
      "orderId": orderId,
      "orderInfo": billInfo,
      "redirectUrl": redirectUrl,
      "ipnUrl": ipnUrl,
      "requestType": "payWithMethod",
      "extraData": "",
      "lang": "en",
      "signature": generateSignature(secretKey, {
        "partnerCode": partnerCode,
        "accessKey": accessKey,
        "requestId": requestId,
        "amount": totalAmount.toString(),
        "orderId": orderId,
        "orderInfo": billInfo,
        "redirectUrl": redirectUrl,
        "ipnUrl": ipnUrl,
        "extraData": "",
        "requestType": "payWithMethod",
      }),
    };

    debugPrint('Momo request: ${jsonEncode(payload)}');
    try {
      debugPrint('Sending request to MoMo...');
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(payload),
      );

      debugPrint('MoMo Response Status: ${response.statusCode}');
      debugPrint('MoMo Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final deeplink = responseData["payUrl"];

        if (deeplink != null) {
          debugPrint('=== URL LAUNCHER DEBUG ===');
          debugPrint('Original deeplink: $deeplink');
          debugPrint('Deeplink type: ${deeplink.runtimeType}');

          try {
            final uri = Uri.parse(deeplink);
            debugPrint('Parsed URI: $uri');
            debugPrint('URI scheme: ${uri.scheme}');
            debugPrint('URI host: ${uri.host}');
            debugPrint('URI path: ${uri.path}');
            debugPrint('URI query: ${uri.query}');

            // Kiểm tra canLaunchUrl
            debugPrint('Checking canLaunchUrl...');
            final canLaunch = await canLaunchUrl(uri);
            debugPrint('canLaunchUrl result: $canLaunch');

            if (canLaunch) {
              debugPrint('Attempting to launch URL...');
              final result = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              debugPrint('URL launch result: $result');

              if (!result) {
                debugPrint(
                    'Launch returned false - trying alternative methods...');

                // Thử phương pháp thay thế
                try {
                  final result2 = await launchUrl(
                    uri,
                    mode: LaunchMode.platformDefault,
                  );
                  debugPrint('Alternative launch result: $result2');
                  if (!result2) {
                    throw "Không thể mở ứng dụng thanh toán. Vui lòng kiểm tra xem ứng dụng MoMo đã được cài đặt chưa.";
                  }
                } catch (e2) {
                  debugPrint('Alternative launch failed: $e2');
                  throw "Không thể mở ứng dụng thanh toán. Vui lòng kiểm tra xem ứng dụng MoMo đã được cài đặt chưa.";
                }
              }
            } else {
              debugPrint('canLaunchUrl returned false');
              // Thử mở bằng browser nếu không thể mở app
              try {
                debugPrint('Trying to open in browser...');
                final browserResult = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                debugPrint('Browser launch result: $browserResult');
                if (!browserResult) {
                  throw "Không thể mở đường dẫn: $deeplink. Vui lòng kiểm tra xem ứng dụng MoMo đã được cài đặt chưa hoặc thử mở trong trình duyệt.";
                }
              } catch (e3) {
                debugPrint('Browser launch failed: $e3');

                // Thử phương pháp cuối cùng với external_app_launcher
                try {
                  debugPrint('Trying external_app_launcher...');
                  await LaunchApp.openApp(
                    androidPackageName: "com.mservice.momotransfer",
                    iosUrlScheme: "momo://",
                    appStoreLink:
                        "https://play.google.com/store/apps/details?id=com.mservice.momotransfer",
                  );
                  debugPrint('External app launcher succeeded');
                } catch (e4) {
                  debugPrint('External app launcher failed: $e4');
                  throw "Không thể mở ứng dụng thanh toán. Vui lòng kiểm tra xem ứng dụng MoMo đã được cài đặt chưa hoặc cài đặt từ: https://play.google.com/store/apps/details?id=com.mservice.momotransfer";
                }
              }
            }
          } catch (e) {
            debugPrint('Error launching URL: $e');
            debugPrint('Error type: ${e.runtimeType}');
            throw "Lỗi khi mở ứng dụng thanh toán: $e";
          }
        } else {
          debugPrint('Deeplink is null!');
          throw "Không tìm thấy đường dẫn đến app Momo";
        }
      } else {
        throw "Lỗi API: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      debugPrint('Error during MoMo payment: $e');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Lỗi Thanh Toán"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Đóng"),
            )
          ],
        ),
      );
    }
  }

// Hàm tạo chữ ký (signature) theo yêu cầu của Momo
  String generateSignature(String secretKey, Map<String, String> data) {
    final sortedKeys = data.keys.toList()..sort();
    final rawData = sortedKeys.map((key) => "$key=${data[key]}").join("&");
    final key = utf8.encode(secretKey);
    final bytes = utf8.encode(rawData);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }
}
