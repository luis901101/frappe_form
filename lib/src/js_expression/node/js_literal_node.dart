import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// A literal value written directly in the expression, like `1`, `'Option 3'`,
/// `true` or `null`.
class JsLiteralNode extends JsNode {
  final dynamic value;

  const JsLiteralNode(this.value);

  @override
  dynamic evaluate() => value;

  @override
  void collectVariables(Set<JsVariable> out) {}

  @override
  String toString() => value is String ? "'$value'" : '$value';
}
