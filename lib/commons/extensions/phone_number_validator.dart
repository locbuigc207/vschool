mixin PhoneNumberValidator {
  final phoneNumberMaxLength = 10;
  final _expression = RegExp(r'^(0|84)\d{9}$');

  String? phoneNumberValidator(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Vui lòng nhập Số điện thoại';
    } else if (!_expression.hasMatch(phoneNumber)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }
}
