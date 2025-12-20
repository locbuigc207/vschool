import 'package:flutter/material.dart';
import 'package:vschool/commons/extensions/phone_number_validator.dart';
import 'package:vschool/commons/widgets/text_field/primary_text_field.dart';

class PhoneNumberTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final ValueChanged<String?>? onChanged;
  final String? Function(String? value)? validator;
  final bool autofocus;

  const PhoneNumberTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.labelText,
    this.validator,
    this.autofocus = false,
  });

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField>
    with PhoneNumberValidator {
  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      labelText: widget.labelText ?? 'Số điện thoại',
      hintText: 'Nhập số điện thoại',
      inputType: TextInputType.number,
      validator: phoneNumberValidator,
      maxLength: 10,
      autofocus: widget.autofocus,
    );
  }
}
