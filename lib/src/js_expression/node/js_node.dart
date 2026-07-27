import 'package:frappe_form/src/js_expression/js_variable.dart';

/// A node of the syntax tree a JS expression is parsed into.
///
/// Every node knows how to [evaluate] itself against the current variable
/// values and how to report the [JsVariable]s it reads, so an owner can watch
/// them and re-evaluate whenever any of them changes.
///
/// Extend it to add a node kind of your own, the analyzer only ever calls
/// [evaluate] and [collectVariables].
abstract class JsNode {
  const JsNode();

  /// Resolves this node to its current value. The result follows JS types:
  /// `num`, `String`, `bool` or `null`.
  dynamic evaluate();

  /// Adds every [JsVariable] this node reads into [out].
  void collectVariables(Set<JsVariable> out);
}
