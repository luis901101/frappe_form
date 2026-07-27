import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:frappe_form/src/js_expression/js_expression_exception.dart';
import 'package:frappe_form/src/js_expression/js_expression_parser.dart';
import 'package:frappe_form/src/js_expression/js_value_utils.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// A parsed JS expression, ready to be evaluated as often as needed.
///
/// Parse once with [parse] or [tryParse], then call [evaluate] for the raw
/// result or [evaluateAsBool] for its JS truthiness. [variables] lists what the
/// expression reads, so an owner can watch those values and re-evaluate when
/// any of them changes.
///
/// ```dart
/// final expression = JsExpression.parse(
///   "(check_1 == 1 || check_2 == 1) && total > 10",
///   resolveVariable: JsConstantVariable.resolverOf({
///     'check_1': 1,
///     'check_2': 0,
///     'total': 42,
///   }),
/// );
/// expression.evaluateAsBool(); // true
/// ```
///
/// The supported subset covers variables _(including dotted names like
/// `doc.check_1`)_, number, string, `true`, `false` and `null` literals, the
/// `&&`, `||` and `!` logical operators, the `==`, `!=`, `===`, `!==`, `>`,
/// `<`, `>=` and `<=` comparisons, the `+`, `-`, `*`, `/` and `%` arithmetic
/// operators along with the unary `-` and `+`, and grouping parentheses.
/// Anything else _(function calls, array literals, assignments, …)_ raises a
/// [JsExpressionException].
class JsExpression {
  /// The expression this was parsed from.
  final String source;

  /// Root of the syntax tree [source] was parsed into.
  final JsNode root;

  /// Every variable the expression reads, without duplicates and in the order
  /// they first appear.
  final List<JsVariable> variables;

  JsExpression({required this.source, required this.root})
    : variables = _gatherVariables(root);

  /// Parses [source], throwing a [JsExpressionException] when it falls outside
  /// the supported subset.
  static JsExpression parse(
    String source, {
    JsVariableResolver? resolveVariable,
  }) => JsExpression(
    source: source,
    root: JsExpressionParser.parseExpression(
      source,
      resolveVariable: resolveVariable,
    ),
  );

  /// Same as [parse] but returns `null` instead of throwing, reporting the
  /// failure in debug mode.
  static JsExpression? tryParse(
    String? source, {
    JsVariableResolver? resolveVariable,
  }) {
    if (source == null || source.trim().isEmpty) return null;
    try {
      return parse(source, resolveVariable: resolveVariable);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  /// The raw result, as a `num`, `String`, `bool` or `null`.
  dynamic evaluate() => root.evaluate();

  /// The result coerced with JS truthiness, where `null`, `false`, `0`, `NaN`
  /// and the empty string are `false`.
  bool evaluateAsBool() => JsValueUtils.asTruthy(evaluate());

  static List<JsVariable> _gatherVariables(JsNode root) {
    final variables = LinkedHashSet<JsVariable>.identity();
    root.collectVariables(variables);
    return List.unmodifiable(variables);
  }

  @override
  String toString() => source;
}
