import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/widgets/text_field/currency_input_formatter.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final bool readonly;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onEditingComplete;
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
  final bool autofocus;

  const PasswordTextField({
    Key? key,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.readonly = false,
    this.onChanged,
    this.onEditingComplete,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.maxLength = 200,
    this.maxLines,
    this.inputType,
    this.validator,
    this.suffix,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.isCurrency = false,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late List<TextInputFormatter> _inputFormatter;
  var isHidden = true;

  @override
  void initState() {
    super.initState();
    _inputFormatter = [
      LengthLimitingTextInputFormatter(widget.maxLength),
    ];
    if (widget.isCurrency) {
      _inputFormatter.add(CurrencyFormatter());
    }
    if (widget.inputType == TextInputType.number) {
      _inputFormatter.add(FilteringTextInputFormatter.digitsOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      readOnly: widget.readonly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      keyboardType: widget.inputType,
      obscureText: isHidden,
      enableSuggestions: widget.enableSuggestions,
      autocorrect: widget.autocorrect,
      autofocus: widget.autofocus,
      inputFormatters: _inputFormatter,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.controller?.text.isEmpty ?? true
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () {
                      widget.controller?.clear();
                      setState(() {});
                    },
                    child: Assets.icons.roundedClear.svg(),
                  ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
              child: isHidden
                  ? Assets.icons.eye.svg(
                      colorFilter: ColorFilter.mode(
                          ColorName.borderColor, BlendMode.srcIn),
                    )
                  : Assets.icons.eyeOff.svg(
                      colorFilter: ColorFilter.mode(
                          ColorName.borderColor, BlendMode.srcIn),
                    ),
            ),
            SizedBox(width: 25.w),
          ],
        ),
      ),
    );
  }
}
