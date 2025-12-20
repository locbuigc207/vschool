import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/extensions/number_ext.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/invoice/invoice_model.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/pages/invoice/bloc/invoice_detail_bloc.dart';

class InvoiceDetailCard extends StatefulWidget {
  final InvoiceInfoModel invoice;
  final ChildrenInfoModel child;
  final void Function(InvoiceInfoModel infoModel)? onTap;

  const InvoiceDetailCard(
      {Key? key, required this.invoice, this.onTap, required this.child})
      : super(key: key);

  @override
  State<InvoiceDetailCard> createState() => _InvoiceDetailCardState();
}

class _InvoiceDetailCardState extends State<InvoiceDetailCard>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tmp = context.select((InvoiceDetailBloc bloc) {
      final state = bloc.state;
      return state is InvoiceDetailChanged ? state.lstInvoice : null;
    });
    if (tmp != null) {
      bool wasSelected = isSelected;
      isSelected = tmp.contains(widget.invoice);

      // Trigger animation when selection state changes
      if (wasSelected != isSelected) {
        if (isSelected) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }

    return Wrap(
      spacing: 2.w,
      runSpacing: 10.h,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: InkWell(
                onTap: () => widget.onTap?.call(widget.invoice),
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        border: Border.all(
                          color: widget.invoice.status == 0
                              ? (isSelected
                                  ? ColorName.blue
                                  : Colors.transparent)
                              : Colors.green,
                          width: 1.0,
                        ),
                        boxShadow: widget.invoice.status == 0 && isSelected
                            ? [
                                BoxShadow(
                                  color: ColorName.blue.withOpacity(0.2),
                                  blurRadius: 8.0,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : widget.invoice.status == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.2),
                                      blurRadius: 8.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: widget.invoice.status == 0
                                    ? (isSelected
                                        ? Container(
                                            width: 20.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              color: ColorName.blue,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          )
                                        : Container(
                                            width: 20.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorName.textGray4,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                          ))
                                    : Container(
                                        width: 20.w,
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: Text(
                                  widget.invoice.content ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Sarabun',
                                    color: widget.invoice.status == 0
                                        ? (isSelected
                                            ? ColorName.blue
                                            : ColorName.textColor)
                                        : Colors.green,
                                  ),
                                ),
                              ),
                              Container(
                                height: 32.h,
                                child: ElevatedButton(
                                  onPressed: () => context.pushRoute(
                                      InvoiceInfoDetailRoute(
                                          invoice: widget.invoice,
                                          child: widget.child)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.invoice.status == 0
                                        ? (isSelected
                                            ? ColorName.blue
                                            : ColorName.blue.withOpacity(0.1))
                                        : Colors.green,
                                    foregroundColor: widget.invoice.status == 0
                                        ? (isSelected
                                            ? Colors.white
                                            : ColorName.blue)
                                        : Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 6.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Chi tiết',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sarabun',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              SizedBox(width: 40.w),
                              Text(
                                'Số tiền: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.w500,
                                  color: widget.invoice.status == 0
                                      ? (isSelected
                                          ? ColorName.blue
                                          : ColorName.textGray2)
                                      : Colors.green,
                                ),
                              ),
                              Text(
                                (widget.invoice.cost ?? 0).formatCurrency(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                  color: widget.invoice.status == 0
                                      ? ColorName.blue
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
