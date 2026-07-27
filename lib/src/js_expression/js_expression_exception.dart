/// Thrown while tokenizing or parsing an expression that falls outside the
/// JavaScript subset the analyzer understands.
///
/// Nothing is thrown while evaluating, so once an expression is parsed it can
/// be evaluated as often as needed without guarding.
class JsExpressionException implements Exception {
  /// A human readable explanation of what could not be interpreted.
  final String message;

  /// The full expression being parsed.
  final String expression;

  /// The character offset within [expression] where the problem was detected.
  final int position;

  const JsExpressionException(
    this.message, {
    required this.expression,
    required this.position,
  });

  @override
  String toString() =>
      'JsExpressionException: $message (at $position in "$expression")';
}
