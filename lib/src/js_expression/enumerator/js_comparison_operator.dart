import 'package:collection/collection.dart';

/// The comparison operators of a JS expression.
enum JsComparisonOperator {
  /// Loose equality. Numbers and numeric strings are compared as numbers,
  /// booleans as `1`/`0`, anything else as strings.
  equals('=='),

  /// Loose inequality, the negation of [equals].
  notEquals('!='),

  /// Strict equality. No coercion at all, so `'1' === 1` is false.
  strictEquals('==='),

  /// Strict inequality, the negation of [strictEquals].
  strictNotEquals('!=='),

  /// True when the left value is greater than or equal to the right one.
  greaterOrEquals('>='),

  /// True when the left value is less than or equal to the right one.
  lessOrEquals('<='),

  /// True when the left value is greater than the right one.
  greaterThan('>'),

  /// True when the left value is less than the right one.
  lessThan('<');

  /// How the operator is written in the expression.
  final String symbol;
  const JsComparisonOperator(this.symbol);

  /// Whether this operator compares without any type coercion.
  bool get isStrict => this == strictEquals || this == strictNotEquals;

  /// Whether this operator is an equality check, either loose or strict.
  bool get isEquality =>
      this == equals ||
      this == notEquals ||
      this == strictEquals ||
      this == strictNotEquals;

  /// Operators binding looser than the relational ones.
  static List<String> get equalitySymbols => JsComparisonOperator.values
      .where((value) => value.isEquality)
      .map((value) => value.symbol)
      .toList();

  /// Operators binding tighter than the equality ones.
  static List<String> get relationalSymbols => JsComparisonOperator.values
      .where((value) => !value.isEquality)
      .map((value) => value.symbol)
      .toList();

  static List<String> get symbols =>
      JsComparisonOperator.values.map((value) => value.symbol).toList();

  static JsComparisonOperator? valueOf(String? symbol) => JsComparisonOperator
      .values
      .firstWhereOrNull((value) => value.symbol == symbol);
}
