import 'package:frappe_form/src/js_expression/enumerator/js_logical_operator.dart';
import 'package:frappe_form/src/js_expression/js_value_utils.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// A `&&` or `||` between two operands, short circuiting like JS does.
class JsLogicalNode extends JsNode {
  final JsLogicalOperator operator;
  final JsNode left;
  final JsNode right;

  const JsLogicalNode({
    required this.operator,
    required this.left,
    required this.right,
  });

  @override
  bool evaluate() {
    final leftValue = JsValueUtils.asTruthy(left.evaluate());
    return switch (operator) {
      JsLogicalOperator.and =>
        leftValue && JsValueUtils.asTruthy(right.evaluate()),
      JsLogicalOperator.or =>
        leftValue || JsValueUtils.asTruthy(right.evaluate()),
    };
  }

  @override
  void collectVariables(Set<JsVariable> out) {
    left.collectVariables(out);
    right.collectVariables(out);
  }

  @override
  String toString() => '($left ${operator.symbol} $right)';
}
