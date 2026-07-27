import 'package:frappe_form/src/js_expression/enumerator/js_unary_operator.dart';
import 'package:frappe_form/src/js_expression/js_value_utils.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// A `!`, `-` or `+` applied to a single operand.
class JsUnaryNode extends JsNode {
  final JsUnaryOperator operator;
  final JsNode operand;

  const JsUnaryNode({required this.operator, required this.operand});

  @override
  dynamic evaluate() {
    final value = operand.evaluate();
    return switch (operator) {
      JsUnaryOperator.not => !JsValueUtils.asTruthy(value),
      JsUnaryOperator.negate => JsValueUtils.negate(value),
      JsUnaryOperator.positive => JsValueUtils.toPositive(value),
    };
  }

  @override
  void collectVariables(Set<JsVariable> out) => operand.collectVariables(out);

  @override
  String toString() => '${operator.symbol}$operand';
}
