import 'package:frappe_form/src/js_expression/enumerator/js_token_type.dart';

/// A single lexical unit of a JS expression.
class JsToken {
  final JsTokenType type;

  /// The raw text this token was built from. For a [JsTokenType.identifier] it
  /// is the whole dotted name, like `doc.check_1`.
  final String lexeme;

  /// The already parsed value for literal tokens, `null` otherwise.
  final dynamic value;

  /// Character offset where this token starts.
  final int position;

  const JsToken({
    required this.type,
    required this.lexeme,
    required this.position,
    this.value,
  });

  bool get isEof => type == JsTokenType.eof;

  bool isOperator(String symbol) =>
      type == JsTokenType.operator && lexeme == symbol;

  bool isAnyOperator(Iterable<String> symbols) =>
      type == JsTokenType.operator && symbols.contains(lexeme);

  @override
  String toString() => '${type.name}("$lexeme")';
}
