import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/extensions/number_ext.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

@RoutePage()
class InvoicePaymentPage extends StatefulWidget {
  final List<InvoiceInfoModel> lstInvoice;
  final ChildrenInfoModel child;

  const InvoicePaymentPage(
      {Key? key, required this.child, required this.lstInvoice})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InvoicePaymentPageState();
}

class _InvoicePaymentPageState extends State<InvoicePaymentPage> {
  int totalAmount = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.lstInvoice.length; i++) {
      totalAmount += widget.lstInvoice[i].cost ?? 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thanh toán học phí',
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Số tiền phải nộp',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                      ),
                      SizedBox(height: 20.h),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InvoicePaymentInfo(
                              child: widget.child,
                              invoice: widget.lstInvoice[index],
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(
                                color: Colors.black,
                              ),
                          itemCount: widget.lstInvoice.length),
                      const Divider(
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Tổng tiền',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            totalAmount.formatCurrency(symbol: '₫'),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Sarabun',
                                fontWeight: FontWeight.bold,
                                color: ColorName.linkBlue),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      InkWell(
                        onTap: () {
                          context.pushRoute(PaymentMethodRoute(
                              child: widget.child,
                              lstInvoice: widget.lstInvoice));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Tiến hành thanh toán',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: ColorName.blue,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Assets.icons.wallet.svg(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoicePaymentInfo extends StatelessWidget {
  final InvoiceInfoModel invoice;
  final ChildrenInfoModel child;

  const InvoicePaymentInfo(
      {Key? key, required this.invoice, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invoice.content ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Sarabun',
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: () => context.pushRoute(
                  InvoiceInfoDetailRoute(invoice: invoice, child: child)),
              child: const Text(
                'Click để xem chi tiết',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ColorName.blue,
                  fontFamily: 'Sarabun',
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          (invoice.cost ?? 0).formatCurrency(),
          style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              fontWeight: FontWeight.bold,
              color: ColorName.linkBlue),
        ),
      ],
    );
  }
}
