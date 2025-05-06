import 'package:flutter/services.dart';

/// A TextInputFormatter that:
///  • Limits input to at most [decimals] digits after the decimal point,
///  • Optionally allows a leading '+' or '-' if [allowSigned] is true.
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({
    this.decimals = 2,
    this.allowSigned = false,
  }) : assert(decimals >= 0, 'Decimal range must be non-negative');

  /// how many decimals to allow
  final int decimals;

  /// allow a leading '+' or '-'?
  final bool allowSigned;

  // cache one regex per (decimals, allowSigned) combo for efficiency
  static final _regexCache = <String, RegExp>{};

  RegExp _getRegex() {
    final key = '$decimals-$allowSigned';
    return _regexCache.putIfAbsent(key, () {
      final signPart = allowSigned ? r'[+-]?' : r'';
      if (decimals == 0) {
        // whole numbers only
        return RegExp('^$signPart\\d*\$');
      }
      // digits, optional dot, then up to [decimals] digits
      return RegExp('^$signPart\\d+\\.?\\d{0,$decimals}\$');
    });
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // allow in-progress inputs: empty, just ".", just "-" or "+", or "-." / "+."
    if (text.isEmpty ||
        text == '.' ||
        text == '-' ||
        text == '+' ||
        text == '-.' ||
        text == '+.') {
      return newValue;
    }

    // if it matches our decimal-with-optional-sign pattern, accept
    if (_getRegex().hasMatch(text)) {
      return newValue;
    }

    // otherwise reject this edit
    return oldValue;
  }
}
