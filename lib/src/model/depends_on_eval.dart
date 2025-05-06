import 'package:flutter/foundation.dart';
import 'package:frappe_form/src/logic/enumerator/doc_field_depends_on_condition.dart';
import 'package:frappe_form/src/logic/enumerator/doc_field_depends_on_operator.dart';

class DependsOnEval {
  final String fieldName;
  final DocFieldDependsOnOperator operator;
  final dynamic expectedAnswer;

  DependsOnEval({
    required this.fieldName,
    required this.operator,
    required this.expectedAnswer,
  });

  static List<DependsOnEval> fromExpression(String? expression) {
    if (expression == null || expression.isEmpty) return [];
    final List<DependsOnEval> list = [];
    try {
      final dependsOnParts = expression.split("eval:");
      if (dependsOnParts.length <= 1) return [];
      final evalExpression = dependsOnParts[1];
      _analyzeConditionExpression(evalExpression, list);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return list;
  }

  static void _analyzeConditionExpression(
      String expression, List<DependsOnEval> list) {
    bool hasCondition = false;
    for (final condition in DocFieldDependsOnCondition.values) {
      final conditionExpression = expression.split(condition.name);
      if (conditionExpression.length > 1) {
        hasCondition = true;
        for (final conditionExpressionPart in conditionExpression) {
          _analyzeConditionExpression(conditionExpressionPart, list);
        }
      }
    }
    if (!hasCondition) {
      final dependsOnEval = _fromCleanExpression(expression);
      if (dependsOnEval != null) {
        list.add(dependsOnEval);
      }
    }
  }

  static DependsOnEval? _fromCleanExpression(String? expression) {
    if (expression == null || expression.isEmpty) return null;
    for (final operator in DocFieldDependsOnOperator.values) {
      final operatorParts = expression.split(operator.name);
      if (operatorParts.length == 2) {
        final fieldName = operatorParts[0].trim().replaceAll('doc.', '');
        if (fieldName.isEmpty) return null;
        String expectedAnswer =
            operatorParts[1].trim().replaceAll('\'', '').replaceAll('"', '');
        if (expectedAnswer.isEmpty) return null;
        return DependsOnEval(
          fieldName: fieldName,
          operator: operator,
          expectedAnswer: expectedAnswer,
        );
      }
    }
    return null;
  }
}
