import 'package:flutter/foundation.dart';
import 'package:frappe_form/src/js_expression/js_expression.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:frappe_form/src/model/doc_field_bundle.dart';
import 'package:frappe_form/src/model/doc_field_variable.dart';

/// A parsed DocField depends-on expression, ready to be evaluated against the
/// current form values.
///
/// Build one with [fromExpression] out of any of the three DocField depends-on
/// properties _(`depends_on`, `mandatory_depends_on` and
/// `read_only_depends_on`)_, then call [check] to know whether the condition
/// holds, and [addListener] to be notified whenever any of the referenced
/// fields changes.
///
/// It is a thin Frappe specific layer on top of [JsExpression], which does the
/// actual parsing and evaluation, and [DocFieldVariable], which binds the
/// identifiers of the expression to the form field controllers.
class DocFieldDependsOnBundle {
  /// The prefix Frappe uses to mark an expression as JS code.
  static const String evalPrefix = 'eval:';

  /// The parsed expression, without the [evalPrefix].
  final JsExpression expression;

  /// Every field controller referenced by [expression], without duplicates, so
  /// a listener is registered exactly once per controller even when the same
  /// field appears several times _(as in `doc.a > 1 && doc.a < 5`)_.
  final List<FieldController> dependencyControllers;

  DocFieldDependsOnBundle({required this.expression})
    : dependencyControllers = List.unmodifiable(
        expression.variables.whereType<DocFieldVariable>().map(
          (variable) => variable.controller,
        ),
      );

  /// Parses [expression] into a bundle, or returns `null` when it is empty or
  /// can not be interpreted.
  ///
  /// Both Frappe forms are accepted, the JS one _(`eval:doc.check_1 == 1`)_ and
  /// the plain field name one _(`check_1`)_, which is satisfied whenever that
  /// field holds a truthy value.
  static DocFieldDependsOnBundle? fromExpression(
    String? expression,
    List<DocFieldBundle> itemBundles,
  ) {
    if (expression.isEmpty) return null;
    final source = expression!.trim();
    final jsExpression = JsExpression.tryParse(
      source.startsWith(evalPrefix)
          ? source.substring(evalPrefix.length)
          : source,
      resolveVariable: DocFieldVariable.resolverOf(itemBundles),
    );
    return jsExpression == null
        ? null
        : DocFieldDependsOnBundle(expression: jsExpression);
  }

  /// Whether the expression currently holds, using JS truthiness on its result.
  bool check() => expression.evaluateAsBool();

  /// The raw result of the expression, as a `num`, `String`, `bool` or `null`.
  dynamic evaluate() => expression.evaluate();

  void addListener(VoidCallback listener) {
    for (final controller in dependencyControllers) {
      controller.addListener(listener);
    }
  }

  void removeListener(VoidCallback listener) {
    for (final controller in dependencyControllers) {
      controller.removeListener(listener);
    }
  }

  @override
  String toString() => '$evalPrefix$expression';
}
