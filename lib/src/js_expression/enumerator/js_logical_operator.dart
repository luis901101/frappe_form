import 'package:collection/collection.dart';

/// The logical operators of a JS expression.
enum JsLogicalOperator {
  and('&&'),
  or('||');

  /// How the operator is written in the expression.
  final String symbol;
  const JsLogicalOperator(this.symbol);

  static List<String> get symbols =>
      JsLogicalOperator.values.map((value) => value.symbol).toList();

  static JsLogicalOperator? valueOf(String? symbol) => JsLogicalOperator.values
      .firstWhereOrNull((value) => value.symbol == symbol);
}
