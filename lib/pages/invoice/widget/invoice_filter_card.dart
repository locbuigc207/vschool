import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/gen/assets.gen.dart';

class InvoiceFilterCard extends StatefulWidget {
  final bool isSelected;
  final String invoiceFilter;
  final void Function(String invoiceFilter)? onTap;

  const InvoiceFilterCard({
    Key? key,
    this.isSelected = false,
    this.invoiceFilter = '',
    this.onTap,
  }) : super(key: key);

  @override
  State<InvoiceFilterCard> createState() => _InvoiceFilterCardState();
}

class _InvoiceFilterCardState extends State<InvoiceFilterCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap?.call(widget.invoiceFilter),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Text(
              widget.invoiceFilter,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sarabun',
              ),
            ),
            const Spacer(),
            widget.isSelected
                ? Assets.icons.checkBoxBlack.svg()
                : Assets.icons.checkBoxEmpty.svg(),
          ],
        ),
      ),
    );
  }
}
