import 'package:frappe_form/src/js_expression/enumerator/js_arithmetic_operator.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_comparison_operator.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_logical_operator.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_token_type.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_unary_operator.dart';
import 'package:frappe_form/src/js_expression/js_expression_exception.dart';
import 'package:frappe_form/src/js_expression/js_token.dart';

/// Turns a JS expression into a flat list of [JsToken]s.
///
/// It is string-literal aware, so operator symbols inside a quoted value _(like
/// the dashes in `"2025-01-01"` or the slash in `"a/b"`)_ are never mistaken for
/// operators, and it always matches the longest operator first, so `===` is not
/// read as `==` followed by `=`.
class JsExpressionLexer {
  /// Every operator symbol the analyzer understands, longest first so that
  /// `===` wins over `==`, `!==` over `!=` and `>=` over `>`.
  static final List<String> operators = <String>{
    ...JsComparisonOperator.symbols,
    ...JsLogicalOperator.symbols,
    ...JsArithmeticOperator.symbols,
    ...JsUnaryOperator.symbols,
  }.toList()..sort((a, b) => b.length.compareTo(a.length));

  final String expression;
  int _position = 0;

  JsExpressionLexer(this.expression);

  /// Tokenizes the whole [expression], always ending with a [JsTokenType.eof]
  /// token.
  List<JsToken> tokenize() {
    final tokens = <JsToken>[];
    while (true) {
      final token = _next();
      tokens.add(token);
      if (token.isEof) break;
    }
    return tokens;
  }

  JsToken _next() {
    _skipWhitespace();
    if (_isAtEnd) {
      return JsToken(type: JsTokenType.eof, lexeme: '', position: _position);
    }

    final start = _position;
    final char = expression[_position];

    if (char == '(') {
      ++_position;
      return JsToken(
        type: JsTokenType.openParen,
        lexeme: char,
        position: start,
      );
    }
    if (char == ')') {
      ++_position;
      return JsToken(
        type: JsTokenType.closeParen,
        lexeme: char,
        position: start,
      );
    }
    if (char == "'" || char == '"') return _readString(char);
    if (_isDigit(char)) return _readNumber();
    if (_isIdentifierStart(char)) return _readIdentifier();

    for (final operator in operators) {
      if (expression.startsWith(operator, _position)) {
        _position += operator.length;
        return JsToken(
          type: JsTokenType.operator,
          lexeme: operator,
          position: start,
        );
      }
    }

    throw _error('Unexpected character "$char"', start);
  }

  JsToken _readString(String quote) {
    final start = _position;
    ++_position; // Opening quote
    final buffer = StringBuffer();
    while (!_isAtEnd && expression[_position] != quote) {
      final char = expression[_position];
      if (char == r'\') {
        ++_position;
        if (_isAtEnd) break;
        buffer.write(_unescape(expression[_position]));
      } else {
        buffer.write(char);
      }
      ++_position;
    }
    if (_isAtEnd) throw _error('Unterminated string literal', start);
    ++_position; // Closing quote
    final value = buffer.toString();
    return JsToken(
      type: JsTokenType.string,
      lexeme: value,
      value: value,
      position: start,
    );
  }

  String _unescape(String char) => switch (char) {
    'n' => '\n',
    'r' => '\r',
    't' => '\t',
    _ => char,
  };

  JsToken _readNumber() {
    final start = _position;
    while (!_isAtEnd && _isDigit(expression[_position])) {
      ++_position;
    }
    if (!_isAtEnd &&
        expression[_position] == '.' &&
        _isDigit(_charAt(_position + 1))) {
      ++_position; // Decimal separator
      while (!_isAtEnd && _isDigit(expression[_position])) {
        ++_position;
      }
    }
    final lexeme = expression.substring(start, _position);
    final value = int.tryParse(lexeme) ?? double.tryParse(lexeme);
    if (value == null) throw _error('Invalid number "$lexeme"', start);
    return JsToken(
      type: JsTokenType.number,
      lexeme: lexeme,
      value: value,
      position: start,
    );
  }

  /// Reads a possibly dotted identifier, like `qty` or `doc.check_1`, as a
  /// single token. Resolving what the dotted name refers to is left to the
  /// [JsVariableResolver].
  JsToken _readIdentifier() {
    final start = _position;
    _readIdentifierPart();
    while (!_isAtEnd &&
        expression[_position] == '.' &&
        _isIdentifierStart(_charAt(_position + 1))) {
      ++_position; // Member separator
      _readIdentifierPart();
    }
    final name = expression.substring(start, _position);
    return switch (name) {
      'true' => JsToken(
        type: JsTokenType.boolean,
        lexeme: name,
        value: true,
        position: start,
      ),
      'false' => JsToken(
        type: JsTokenType.boolean,
        lexeme: name,
        value: false,
        position: start,
      ),
      'null' || 'undefined' => JsToken(
        type: JsTokenType.nullLiteral,
        lexeme: name,
        position: start,
      ),
      _ => JsToken(type: JsTokenType.identifier, lexeme: name, position: start),
    };
  }

  void _readIdentifierPart() {
    while (!_isAtEnd && _isIdentifierPart(expression[_position])) {
      ++_position;
    }
  }

  void _skipWhitespace() {
    while (!_isAtEnd && _isWhitespace(expression[_position])) {
      ++_position;
    }
  }

  bool get _isAtEnd => _position >= expression.length;

  String _charAt(int index) =>
      index >= 0 && index < expression.length ? expression[index] : '';

  bool _isWhitespace(String char) =>
      char == ' ' || char == '\t' || char == '\n' || char == '\r';

  bool _isDigit(String char) {
    if (char.length != 1) return false;
    final code = char.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39; // 0-9
  }

  bool _isIdentifierStart(String char) {
    if (char.length != 1) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x41 && code <= 0x5A) || // A-Z
        (code >= 0x61 && code <= 0x7A) || // a-z
        char == '_' ||
        char == r'$';
  }

  bool _isIdentifierPart(String char) =>
      _isIdentifierStart(char) || _isDigit(char);

  JsExpressionException _error(String message, int position) =>
      JsExpressionException(
        message,
        expression: expression,
        position: position,
      );
}
