import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// A reference to a variable, like `qty` or `doc.check_1`.
///
/// When [variable] is `null` the [JsVariableResolver] did not know the
/// identifier. The node is kept anyway so the surrounding expression keeps its
/// shape, and it evaluates to `null`, the way JS reads an undefined property.
class JsVariableNode extends JsNode {
  /// The identifier as written in the expression.
  final String name;

  /// What the identifier was bound to, `null` when it could not be resolved.
  final JsVariable? variable;

  const JsVariableNode({required this.name, this.variable});

  /// Whether the identifier was bound to an actual variable.
  bool get isResolved => variable != null;

  @override
  dynamic evaluate() => variable?.value;

  @override
  void collectVariables(Set<JsVariable> out) {
    final variable = this.variable;
    if (variable != null) out.add(variable);
  }

  @override
  String toString() => name;
}
