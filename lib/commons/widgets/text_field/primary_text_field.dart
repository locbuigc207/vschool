import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/text_field/currency_input_formatter.dart';
import 'package:vschool/commons/widgets/text_field/text_field_circular_progress_indicator.dart';
import 'package:vschool/commons/widgets/text_field/uppercase_input_formatter.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class PrimaryTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final bool readonly;
  final bool autofocus;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClear;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final int maxLength;
  final int? maxLines;
  final TextInputType? inputType;
  final String? Function(String? value)? validator;
  final Widget? suffix;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool isCurrency;
  final bool isPlateNumber;
  final bool hasClearButton;
  final bool isLoading;

  const PrimaryTextField({
    Key? key,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readonly = false,
    this.autofocus = false,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onClear,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.maxLength = 200,
    this.maxLines = 1,
    this.inputType,
    this.validator,
    this.suffix,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.isCurrency = false,
    this.isPlateNumber = false,
    this.hasClearButton = true,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  late List<TextInputFormatter> _inputFormatter;

  @override
  void initState() {
    super.initState();
    _inputFormatter = [
      LengthLimitingTextInputFormatter(widget.maxLength),
    ];
    if (widget.isCurrency) {
      _inputFormatter.add(CurrencyFormatter());
    }
    if (widget.isPlateNumber) {
      _inputFormatter.add(UpperCaseInputFormatter());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget suffixOrLoading;
    if (widget.isLoading) {
      suffixOrLoading = const TextFieldCircularProgressIndicator();
    } else if (widget.suffix != null) {
      suffixOrLoading = widget.suffix!;
    } else {
      suffixOrLoading = const SizedBox.shrink();
    }

    final suffixIcon = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        !widget.hasClearButton || (widget.controller?.text.isEmpty ?? true)
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () {
                  widget.controller?.clear();
                  widget.onClear?.call();
                  setState(() {});
                },
                child: Assets.icons.roundedClear.svg(),
              ),
        widget.hasClearButton && (widget.suffix != null || widget.isLoading)
            ? SizedBox(width: 12.w)
            : const SizedBox.shrink(),
        suffixOrLoading,
        SizedBox(width: 20.w),
      ],
    );

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      readOnly: widget.readonly,
      autofocus: widget.autofocus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      keyboardType: widget.inputType,
      obscureText: widget.obscureText,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      inputFormatters: _inputFormatter,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
      maxLines: widget.maxLines,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      onTap: widget.onTap,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        alignLabelWithHint: true,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}
