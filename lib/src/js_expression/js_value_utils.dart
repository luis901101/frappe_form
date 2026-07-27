import 'package:frappe_form/src/logic/utils/num_utils.dart';

/// Value coercion rules used while evaluating a [JsExpression].
///
/// They follow JavaScript semantics, with two deliberate divergences that fit
/// form data better than raw JS:
///
/// - Relational operators compare numerically whenever **both** operands are
///   coercible to a number, even if both are strings. JS would compare
///   `'10' > '9'` lexicographically _(false)_, here it is numeric _(true)_,
///   because text based inputs expose numeric values as strings.
/// - `+` sums whenever both operands are coercible to a number and only
///   concatenates otherwise, so `'1' + '1'` is `2` and not `'11'`.
class JsValueUtils {
  const JsValueUtils._();

  /// JavaScript truthiness: `null`, `false`, `0`, `NaN` and the empty string
  /// are falsy, everything else is truthy.
  static bool asTruthy(dynamic value) => switch (value) {
    null => false,
    bool value => value,
    num value => value != 0 && !value.isNaN,
    String value => value.isNotEmpty,
    _ => true,
  };

  /// Converts [value] to a number, or returns `null` when it can not be
  /// represented as one.
  ///
  /// Booleans become `1`/`0` and the empty string becomes `0`, matching JS
  /// `Number()`. `null` returns `null` so callers can tell "absent" apart from
  /// "zero".
  static num? asNum(dynamic value) => switch (value) {
    null => null,
    num value => value,
    bool value => value ? 1 : 0,
    String value => value.trim().isEmpty ? 0 : NumUtils.tryParse(value),
    _ => NumUtils.tryParse(value.toString()),
  };

  /// Same as [asNum] but for arithmetic operands, where an absent value counts
  /// as `0` and a non numeric value poisons the operation with `NaN`.
  static num asArithmeticNum(dynamic value) =>
      value == null ? 0 : (asNum(value) ?? double.nan);

  /// Converts [value] to a string, treating `null` as the empty string.
  static String asString(dynamic value) => value?.toString() ?? '';

  /// JavaScript `==`.
  static bool looseEquals(dynamic a, dynamic b) {
    if (a == null || b == null) return a == null && b == null;
    if (a is bool || b is bool) {
      return looseEquals(
        a is bool ? (a ? 1 : 0) : a,
        b is bool ? (b ? 1 : 0) : b,
      );
    }
    if (a is String && b is String) return a == b;
    final numA = asNum(a);
    final numB = asNum(b);
    if (numA != null && numB != null) return numA == numB;
    return asString(a) == asString(b);
  }

  /// JavaScript `===`, no coercion at all.
  static bool strictEquals(dynamic a, dynamic b) {
    if (a == null || b == null) return a == null && b == null;
    if (a is num && b is num) return a == b;
    if (a is String && b is String) return a == b;
    if (a is bool && b is bool) return a == b;
    return identical(a, b);
  }

  /// Three way comparison used by `>`, `<`, `>=` and `<=`.
  ///
  /// Returns `null` when the operands are not comparable _(the JS `NaN` case)_,
  /// in which case every relational operator must evaluate to `false`.
  static int? compare(dynamic a, dynamic b) {
    final numA = asNum(a) ?? (a == null ? 0 : null);
    final numB = asNum(b) ?? (b == null ? 0 : null);
    if (numA != null && numB != null) {
      if (numA.isNaN || numB.isNaN) return null;
      return numA.compareTo(numB);
    }
    if (a is String && b is String) return a.compareTo(b);
    return null;
  }

  /// JavaScript `+`, summing numbers and concatenating anything else.
  static dynamic add(dynamic a, dynamic b) {
    final numA = asNum(a);
    final numB = asNum(b);
    if (numA != null && numB != null) return numA + numB;
    return '${asString(a)}${asString(b)}';
  }

  /// `-`, `*`, `/` and `%`, always numeric. Non numeric operands yield `NaN`,
  /// which makes any comparison against the result `false`.
  static num subtract(dynamic a, dynamic b) =>
      asArithmeticNum(a) - asArithmeticNum(b);

  static num multiply(dynamic a, dynamic b) =>
      asArithmeticNum(a) * asArithmeticNum(b);

  static num divide(dynamic a, dynamic b) =>
      asArithmeticNum(a) / asArithmeticNum(b);

  /// Uses [num.remainder] instead of `%` so the sign follows the dividend, as
  /// JavaScript does.
  static num modulo(dynamic a, dynamic b) =>
      asArithmeticNum(a).remainder(asArithmeticNum(b));

  /// Unary `-`.
  static num negate(dynamic value) => -asArithmeticNum(value);

  /// Unary `+`.
  static num toPositive(dynamic value) => asArithmeticNum(value);
}
