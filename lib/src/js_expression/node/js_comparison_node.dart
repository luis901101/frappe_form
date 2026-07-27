import 'package:frappe_form/src/js_expression/enumerator/js_comparison_operator.dart';
import 'package:frappe_form/src/js_expression/js_value_utils.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';

/// A comparison between two operands, like `doc.select == 'Option 3'`.
class JsComparisonNode extends JsNode {
  final JsComparisonOperator operator;
  final JsNode left;
  final JsNode right;

  const JsComparisonNode({
    required this.operator,
    required this.left,
    required this.right,
  });

  @override
  bool evaluate() {
    final leftValue = left.evaluate();
    final rightValue = right.evaluate();
    return switch (operator) {
      JsComparisonOperator.equals => JsValueUtils.looseEquals(
        leftValue,
        rightValue,
      ),
      JsComparisonOperator.notEquals => !JsValueUtils.looseEquals(
        leftValue,
        rightValue,
      ),
      JsComparisonOperator.strictEquals => JsValueUtils.strictEquals(
        leftValue,
        rightValue,
      ),
      JsComparisonOperator.strictNotEquals => !JsValueUtils.strictEquals(
        leftValue,
        rightValue,
      ),
      JsComparisonOperator.greaterThan => _relational(
        leftValue,
        rightValue,
        (result) => result > 0,
      ),
      JsComparisonOperator.greaterOrEquals => _relational(
        leftValue,
        rightValue,
        (result) => result >= 0,
      ),
      JsComparisonOperator.lessThan => _relational(
        leftValue,
        rightValue,
        (result) => result < 0,
      ),
      JsComparisonOperator.lessOrEquals => _relational(
        leftValue,
        rightValue,
        (result) => result <= 0,
      ),
    };
  }

  /// Incomparable operands are the JS `NaN` case, where every relational
  /// operator is `false`.
  bool _relational(dynamic a, dynamic b, bool Function(int result) test) {
    final result = JsValueUtils.compare(a, b);
    return result == null ? false : test(result);
  }

  @override
  void collectVariables(Set<JsVariable> out) {
    left.collectVariables(out);
    right.collectVariables(out);
  }

  @override
  String toString() => '($left ${operator.symbol} $right)';
}
