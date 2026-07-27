/// A named value a JS expression can read.
///
/// This is the seam between the generic expression analyzer and whatever holds
/// the actual data. Implement it to expose your own values to an expression,
/// and hand a [JsVariableResolver] to [JsExpression.parse] so identifiers are
/// bound to them.
abstract class JsVariable {
  /// The identifier this variable is bound to, as written in the expression.
  String get name;

  /// The current value, read every time the expression is evaluated.
  dynamic get value;
}

/// Resolves an identifier found in an expression into the variable it refers
/// to, or `null` when there is no such variable, in which case it reads as
/// `null` _(the JS `undefined`)_.
typedef JsVariableResolver = JsVariable? Function(String name);

/// A [JsVariable] holding a value that never changes. Useful to evaluate an
/// expression against a plain map of values.
class JsConstantVariable implements JsVariable {
  @override
  final String name;

  @override
  final dynamic value;

  const JsConstantVariable(this.name, this.value);

  /// Builds a resolver reading from [values].
  static JsVariableResolver resolverOf(Map<String, dynamic> values) =>
      (name) => values.containsKey(name)
      ? JsConstantVariable(name, values[name])
      : null;

  @override
  String toString() => '$name=$value';
}
