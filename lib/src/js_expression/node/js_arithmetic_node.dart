import 'package:frappe_form/src/js_expression/enumerator/js_arithmetic_operator.dart';
import 'package:frappe_form/src/js_expression/js_value_utils.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// An arithmetic operation between two operands, like `doc.check_1 + doc.check_2`.
class JsArithmeticNode extends JsNode {
  final JsArithmeticOperator operator;
  final JsNode left;
  final JsNode right;

  const JsArithmeticNode({
    required this.operator,
    required this.left,
    required this.right,
  });

  @override
  dynamic evaluate() {
    final leftValue = left.evaluate();
    final rightValue = right.evaluate();
    return switch (operator) {
      JsArithmeticOperator.add => JsValueUtils.add(leftValue, rightValue),
      JsArithmeticOperator.subtract => JsValueUtils.subtract(
        leftValue,
        rightValue,
      ),
      JsArithmeticOperator.multiply => JsValueUtils.multiply(
        leftValue,
        rightValue,
      ),
      JsArithmeticOperator.divide => JsValueUtils.divide(leftValue, rightValue),
      JsArithmeticOperator.modulo => JsValueUtils.modulo(leftValue, rightValue),
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
