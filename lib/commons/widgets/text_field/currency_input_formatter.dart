import 'package:flutter/services.dart';
import 'package:vschool/commons/extensions/number_ext.dart';

class CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueInt = int.tryParse(newValue.text.replaceAll('.', ''));
    if (newValueInt == null) return newValue;
    final newValueStr = newValueInt.formatCurrency();
    TextSelection cursor;
    if (newValueStr.length > newValue.text.length) {
      cursor = newValue.selection.copyWith(
        baseOffset: newValue.selection.baseOffset + 1,
        extentOffset: newValue.selection.extentOffset + 1,
      );
    } else if (newValueStr.length == newValue.text.length) {
      cursor = newValue.selection;
    } else {
      cursor = newValue.selection.copyWith(
        baseOffset: newValue.selection.baseOffset - 1,
        extentOffset: newValue.selection.extentOffset - 1,
      );
    }
    final newNewValue = newValue.copyWith(
      text: newValueStr,
      selection: cursor,
    );
    return newNewValue;
  }
}
