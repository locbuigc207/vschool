import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/extensions/number_ext.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
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

@RoutePage()
class InvoiceInfoDetailPage extends StatefulWidget {
  final InvoiceInfoModel invoice;
  final ChildrenInfoModel child;

  const InvoiceInfoDetailPage({
    super.key,
    required this.invoice,
    required this.child,
  });

  @override
  State<InvoiceInfoDetailPage> createState() => _InvoiceInfoDetailPageState();
}

class _InvoiceInfoDetailPageState extends State<InvoiceInfoDetailPage> {
  List<InvoiceInfoModel> lstInvoice = [];

  @override
  void initState() {
    lstInvoice.add(widget.invoice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc(
          userRepository: getIt<IUserRepository>(), appBloc: getIt<AppBloc>())
        ..add(GetSchoolInfo(studentId: widget.child.studentId!)),
      child: BasePage(
        backgroundColor: Colors.white,
        title: 'Chi tiết hóa đơn',
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
                  padding: EdgeInsets.fromLTRB(30.w, 24.h, 30.w, 32.h),
                  child: BlocBuilder<HomePageBloc, HomePageState>(
                    builder: (context, homeState) {
                      var studentInfo = '';
                      if (homeState is GetSchoolSuccess) {
                        studentInfo = homeState.schoolInfoModel;
                      }

                      return SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  widget.invoice.content ?? '',
                                  style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Sarabun'),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  widget.invoice.status == 0
                                      ? const Text(
                                          'Có thể thanh toán',
                                          style: TextStyle(
                                              color: ColorName.linkBlue,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              fontFamily: 'Sarabun'),
                                        )
                                      : const Text(
                                          'Đã thanh toán',
                                          style: TextStyle(
                                              color: ColorName.foam,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              fontFamily: 'Sarabun'),
                                        ),
                                  const Spacer(),
                                  Text(
                                    (widget.invoice.cost ?? 0)
                                        .formatCurrency(symbol: 'vnđ'),
                                    style: TextStyle(
                                        color: widget.invoice.status == 0
                                            ? ColorName.linkBlue
                                            : ColorName.foam,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        fontFamily: 'Sarabun'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Text(
                                widget.child.name ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'Sarabun'),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 280.w,
                                    child: Text(
                                      studentInfo,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Sarabun',
                                          color: ColorName.borderColor),
                                      maxLines: 5,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  const Spacer(),
                                  Assets.icons.traficSign.svg(),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                widget.invoice.description ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontFamily: 'Sarabun'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            widget.invoice.status == 0
                ? Positioned(
                    bottom: 20.h,
                    right: 20.w,
                    child: SafeArea(
                      child: InkWell(
                        onTap: () {
                          context.pushRoute(InvoicePaymentRoute(
                              child: widget.child, lstInvoice: lstInvoice));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Thanh toán ngay',
                              style: TextStyle(
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
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
