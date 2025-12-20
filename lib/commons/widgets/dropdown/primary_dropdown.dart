import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

import 'dropdown.dart';

class DropdownItem {
  final String? title;
  final String? value;

  DropdownItem({
    required this.title,
    required this.value,
  });

  @override
  String toString() {
    return title ?? '';
  }
}

class PrimaryDropdown<T extends DropdownItem> extends StatefulWidget {
  final T? selectedItem;
  final List<T> items;
  final String? label;
  final double? dropdownHeight;
  final String emptyText;
  final String emptyActionText;
  final void Function(T? item)? onChanged;
  final bool hasClearButton;
  final void Function(T? item)? onClear;
  final Widget? suffix;
  final bool enabled;
  final String? Function(T?)? validator;

  const PrimaryDropdown({
    super.key,
    this.selectedItem,
    required this.items,
    this.label,
    this.dropdownHeight,
    this.emptyText = 'Không có dữ liệu',
    this.emptyActionText = '',
    this.onChanged,
    this.hasClearButton = true,
    this.onClear,
    this.suffix,
    this.enabled = true,
    this.validator,
  });

  @override
  State<PrimaryDropdown<T>> createState() => _PrimaryDropdownState<T>();
}

class _PrimaryDropdownState<T extends DropdownItem>
    extends State<PrimaryDropdown<T>> {
  final _controller = DropdownEditingController<T>();

  @override
  void initState() {
    _controller.value = widget.selectedItem;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownFormField<T>(
      controller: _controller,
      enabled: widget.enabled,
      overlayDistance: 8.h,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      dropdownHeight: widget.dropdownHeight ?? 250.h,
      onEmptyActionPressed: () async {},
      emptyText: widget.emptyText,
      emptyActionText: widget.emptyActionText,
      validator: widget.validator,
      onChanged: (item) {
        widget.onChanged?.call(item);
        // to rebuild clear icon
        setState(() {});
      },
      displayItemFn: (item) {
        var displayText = item?.title?.trim() ?? '';
        // if (displayText.length > 24) {
        //   displayText = displayText.replaceRange(22, displayText.length, '...');
        // }

        return Text(
          displayText,
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
        );
      },
      findFn: (_) async => widget.items,
      selectedFn: (item1, item2) {
        if (item1 != null && item2 != null) {
          return item1.value == item2.value;
        }
        return false;
      },
      filterFn: (item, str) {
        final itemString = item.title?.toLowerCase() ?? '';
        final searchString = str.toLowerCase();
        final itemStringNoAccent = TiengViet.parse(itemString);
        final searchStringNoAccent = TiengViet.parse(searchString);

        return itemStringNoAccent.contains(searchStringNoAccent);
      },
      dropdownItemFn: (
        T item,
        int position,
        bool focused,
        bool selected,
        Function() onTap,
      ) {
        return ListTile(
          title: Text(
            item.title ?? '',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 0.h,
          ),
          tileColor: selected ? ColorName.textGray7 : Colors.white,
          trailing: selected
              ? const Icon(
                  Icons.check_rounded,
                  size: 24.0,
                  color: Color(0xFF73777A),
                )
              : const SizedBox.shrink(),
          onTap: onTap,
        );
      },
      searchTextStyle:
          Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
        labelText: widget.label,
        // hintText: 'Access',
        errorText: widget.validator?.call(_controller.value),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorName.borderColor),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorName.primaryColor),
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorName.error),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorName.error),
          borderRadius: BorderRadius.circular(16.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorName.disabledBorderColor),
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorMaxLines: 2,
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: ColorName.error,
        ),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.hasClearButton && _controller.value != null
                ? GestureDetector(
                    onTap: () {
                      _controller.value = null;
                      widget.onChanged?.call(null);
                      setState(() {});
                    },
                    child: Assets.icons.roundedClear.svg(),
                  )
                : const SizedBox.shrink(),
            widget.suffix != null
                ? SizedBox(width: 12.w)
                : const SizedBox.shrink(),
            widget.suffix != null ? widget.suffix! : const SizedBox.shrink(),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}
