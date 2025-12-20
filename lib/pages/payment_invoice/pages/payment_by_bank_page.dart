import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/payment_channel/payment_channel_model.dart';
import 'package:vschool/commons/repository/payment_method_repository.dart';
import 'package:vschool/commons/services/local_file_service/local_file_service.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/notification/widget/notification_shimmer_loading.dart';
import 'package:vschool/pages/payment_invoice/bloc/payment_invoice_bloc.dart';

@RoutePage()
class PaymentByBankPage extends StatefulWidget {
  const PaymentByBankPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentByBankPageState();
}

class _PaymentByBankPageState extends State<PaymentByBankPage> {
  final TextEditingController _searchQuery = TextEditingController();
  List<PaymentChannelInfoModel> lstPaymentMethods = [];
  List<PaymentChannelInfoModel> _foundMethod = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PaymentInvoiceBloc(
              paymentMethodRepository: getIt<IPaymentMethodRepository>(),
              localFileService: getIt<ILocalFileService>())
            ..add(PaymentMethodFetch()),
        ),
      ],
      child: BlocConsumer<PaymentInvoiceBloc, PaymentInvoiceState>(
        listener: (context, state) {
          print('PaymentByBankPage - State changed: $state');
          if (state is PaymentMethodFetching) {
            print('PaymentByBankPage - Loading payment methods...');
            context.loaderOverlay.show();
          } else if (state is PaymentMethodFetchFailure) {
            print('PaymentByBankPage - Failed to load payment methods: ${state.mess}');
            context.loaderOverlay.hide();
            showErrorSnackBBar(context: context, message: state.mess);
          } else if (state is PaymentMethodFetchSuccess) {
            print('PaymentByBankPage - Successfully loaded ${state.lstPaymentMethod?.length ?? 0} payment methods');
            context.loaderOverlay.hide();
            lstPaymentMethods = state.lstPaymentMethod ?? [];
            _foundMethod = lstPaymentMethods;
            print('PaymentByBankPage - Updated lstPaymentMethods: ${lstPaymentMethods.length}');
          }
        },
        builder: (context, state) {
          print('PaymentByBankPage - Builder called with state: $state');
          print('PaymentByBankPage - lstPaymentMethods.length: ${lstPaymentMethods.length}');
          return BasePage(
            backgroundColor: Colors.white,
            title: 'Chọn Ngân Hàng Nội Địa',
            child: Stack(
              children: [
                FadeAnimation(
                  delay: 0.5,
                  child: GradientHeaderContainer(height: 140.h),
                ),
                SafeArea(
                  child: FadeAnimation(
                    delay: 1,
                    direction: FadeDirection.up,
                    child: RoundedTopContainer(
                      margin: EdgeInsets.only(top: 16.h),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 10.h),
                      child: SingleChildScrollView(
                        child: lstPaymentMethods.isEmpty
                            ? const NotificationShimmerLoading()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Bạn dùng',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Sarabun',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _searchQuery,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value = _searchQuery.text
                                              .toString()
                                              .toUpperCase();
                                          _foundMethod = lstPaymentMethods
                                              .where((element) => element.name
                                                  .toString()
                                                  .toUpperCase()
                                                  .contains(value))
                                              .toList();
                                        },
                                      );
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'ngân hàng nào?',
                                      hintStyle: TextStyle(
                                        color: ColorName.textGray5,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Sarabun',
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Sarabun',
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return PaymentMethodCard(
                                          paymentChannel: _foundMethod[index],
                                          onTap: (paymentChannel) async {
                                            if (paymentChannel.androidStoreId != null || 
                                                paymentChannel.iosStoreId != null) {
                                              await LaunchApp.openApp(
                                                androidPackageName:
                                                    paymentChannel.androidStoreId ?? '',
                                                iosUrlScheme:
                                                    paymentChannel.iosStoreId ?? '',
                                                openStore: true,
                                              );
                                            }
                                          },
                                        );
                                      },
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 30),
                                      itemCount: _foundMethod.length)
                                ],
                              ),
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

class PaymentMethodCard extends StatelessWidget {
  final PaymentChannelInfoModel paymentChannel;
  final void Function(PaymentChannelInfoModel paymentChannel)? onTap;

  const PaymentMethodCard({Key? key, required this.paymentChannel, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(paymentChannel),
      child: Row(
        children: [
          Column(
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 6.w),
              //   decoration: BoxDecoration(
              //     gradient: const LinearGradient(
              //       colors: [
              //         Colors.white,
              //         ColorName.textGray5,
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     border: Border.all(color: ColorName.borderColor, width: 0.5),
              //     borderRadius: const BorderRadius.all(Radius.circular(8)),
              //     boxShadow: const [
              //       BoxShadow(
              //         color: ColorName.borderColor,
              //         spreadRadius: 1,
              //         blurRadius: 4,
              //         offset: Offset(0, 3),
              //       )
              //     ],
              //   ),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Image.memory(
              //         base64Decode(paymentChannel.icon),
              //         width: 42,
              //         height: 42,
              //       ),
              //     ],
              //   ),
              // ),
              if (paymentChannel.bankIcon != null)
                Image.memory(
                  base64Decode(paymentChannel.bankIcon!),
                  width: 60,
                ),
            ],
          ),
          SizedBox(width: 20.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paymentChannel.name ?? 'Không có tên',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sarabun'),
                ),
                SizedBox(height: 10.h),
                Text(paymentChannel.description ?? 'Không có mô tả'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
