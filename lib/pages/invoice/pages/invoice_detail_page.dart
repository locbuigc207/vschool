import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/repository/invoice_repository.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_bloc.dart';
import 'package:vschool/pages/invoice/bloc/invoice_detail_bloc.dart';
import 'package:vschool/pages/invoice/widget/invoice_detail_card.dart';

@RoutePage()
class InvoiceDetailPage extends StatefulWidget {
  final ChildrenInfoModel child;

  const InvoiceDetailPage({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  List<InvoiceInfoModel> lstInvoicePaid = [];
  List<InvoiceInfoModel> lstInvoiceNotPaid = [];

  List<InvoiceInfoModel> lstSelected = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thông tin hóa đơn',
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
                margin: EdgeInsets.only(top: 16.h, bottom: 30.h),
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => InvoicePageBloc(
                            invoiceRepository: getIt<IInvoiceRepository>())
                          ..add(GetAllStudentInvoice(
                              studentId: widget.child.studentId!))),
                    BlocProvider(
                        create: (_) => InvoiceDetailBloc(
                            invoiceRepository: getIt<IInvoiceRepository>())),
                    BlocProvider(
                        create: (_) => HomePageBloc(
                            userRepository: getIt<IUserRepository>(),
                            appBloc: getIt<AppBloc>())),
                  ],
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<InvoicePageBloc, InvoicePageState>(
                        listener: (context, state) {
                          if (state.isLoading == true) {
                            context.loaderOverlay.show();
                          } else {
                            context.loaderOverlay.hide();
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<HomePageBloc, HomePageState>(
                      builder: (context, homeState) {
                        return BlocBuilder<InvoicePageBloc, InvoicePageState>(
                          builder: (context, invoiceState) {
                            var lstInvoice = invoiceState.lstInvoice;
                            lstInvoiceNotPaid = lstInvoice
                                .where((element) => element.status == 0)
                                .toList();
                            lstInvoicePaid = lstInvoice
                                .where((element) => element.status == 1)
                                .toList();

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Text(
                                        '*Chú ý: Phụ huynh có thể chọn 1 hoặc nhiều hóa đơn để thanh toán',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Sarabun'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    'Chưa đóng (${lstInvoiceNotPaid.length})',
                                    style: const TextStyle(
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
                                  SizedBox(height: 36.h),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InvoiceDetailCard(
                                          onTap: (infoModel) {
                                            setState(() {
                                              if (!lstSelected
                                                  .contains(infoModel)) {
                                                lstSelected.add(infoModel);
                                                context
                                                    .read<InvoiceDetailBloc>()
                                                    .add(InvoiceDetailChange(
                                                        lstInvoice:
                                                            lstSelected));
                                              } else {
                                                lstSelected.remove(infoModel);
                                                context
                                                    .read<InvoiceDetailBloc>()
                                                    .add(InvoiceDetailChange(
                                                        lstInvoice:
                                                            lstSelected));
                                              }
                                            });
                                          },
                                          child: widget.child,
                                          invoice: lstInvoiceNotPaid[index]);
                                    },
                                    separatorBuilder: (_, __) =>
                                        const SizedBox.shrink(),
                                    itemCount: lstInvoiceNotPaid.length,
                                  ),
                                  SizedBox(height: 34.h),
                                  Text(
                                    'Đã đóng (${lstInvoicePaid.length})',
                                    style: const TextStyle(
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
                                  SizedBox(height: 36.h),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InvoiceDetailCard(
                                          child: widget.child,
                                          invoice: lstInvoicePaid[index]);
                                    },
                                    separatorBuilder: (_, __) =>
                                        const SizedBox.shrink(),
                                    itemCount: lstInvoicePaid.length,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          lstSelected.isNotEmpty
              ? SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        context.pushRoute(InvoicePaymentRoute(
                            child: widget.child, lstInvoice: lstSelected));
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(
                              color: ColorName.borderColor,
                              width: 0.5,
                            ))),
                        height: 60.h,
                        child: Row(
                          children: [
                            SizedBox(width: 30.w),
                            Text(
                              '(${lstSelected.length}) Thanh toán',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: ColorName.blue,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Assets.icons.wallet.svg(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
