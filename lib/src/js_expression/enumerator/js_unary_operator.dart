import 'package:collection/collection.dart';

/// The unary operators of a JS expression.
///
/// [negate] and [positive] share their symbol with
/// [JsArithmeticOperator.subtract] and [JsArithmeticOperator.add], it is the
/// position in the expression what tells them apart.
enum JsUnaryOperator {
  /// Logical negation, `!value`.
  not('!'),

  /// Sign inversion, `-value`.
  negate('-'),

  /// Explicit positive sign, `+value`.
  positive('+');

  /// How the operator is written in the expression.
  final String symbol;
  const JsUnaryOperator(this.symbol);

  static List<String> get symbols =>
      JsUnaryOperator.values.map((value) => value.symbol).toList();

  static JsUnaryOperator? valueOf(String? symbol) => JsUnaryOperator.values
      .firstWhereOrNull((value) => value.symbol == symbol);
}
