import 'package:collection/collection.dart';

/// The arithmetic operators of a JS expression.
enum JsArithmeticOperator {
  add('+'),
  subtract('-'),
  multiply('*'),
  divide('/'),
  modulo('%');

  /// How the operator is written in the expression.
  final String symbol;
  const JsArithmeticOperator(this.symbol);

  /// Operators binding tighter than [add] and [subtract].
  bool get isMultiplicative =>
      this == multiply || this == divide || this == modulo;

  /// The `+` and `-` operators.
  static List<String> get additiveSymbols => JsArithmeticOperator.values
      .where((value) => !value.isMultiplicative)
      .map((value) => value.symbol)
      .toList();

  /// The `*`, `/` and `%` operators.
  static List<String> get multiplicativeSymbols => JsArithmeticOperator.values
      .where((value) => value.isMultiplicative)
      .map((value) => value.symbol)
      .toList();

  static List<String> get symbols =>
      JsArithmeticOperator.values.map((value) => value.symbol).toList();

  static JsArithmeticOperator? valueOf(String? symbol) => JsArithmeticOperator
      .values
      .firstWhereOrNull((value) => value.symbol == symbol);
}
