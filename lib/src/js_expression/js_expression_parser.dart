import 'package:frappe_form/src/js_expression/enumerator/js_arithmetic_operator.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_comparison_operator.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_logical_operator.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_token_type.dart';
import 'package:frappe_form/src/js_expression/enumerator/js_unary_operator.dart';
import 'package:frappe_form/src/js_expression/js_expression_exception.dart';
import 'package:frappe_form/src/js_expression/js_expression_lexer.dart';
import 'package:frappe_form/src/js_expression/js_token.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/js_expression/node/js_arithmetic_node.dart';
import 'package:frappe_form/src/js_expression/node/js_comparison_node.dart';
import 'package:frappe_form/src/js_expression/node/js_literal_node.dart';
import 'package:frappe_form/src/js_expression/node/js_logical_node.dart';
import 'package:frappe_form/src/js_expression/node/js_node.dart';
import 'package:frappe_form/src/js_expression/node/js_unary_node.dart';
import 'package:frappe_form/src/js_expression/node/js_variable_node.dart';

/// Recursive descent parser for the subset of JavaScript the analyzer supports:
///
/// ```
/// expression      := orExpr
/// orExpr          := andExpr        ( '||' andExpr )*
/// andExpr         := equality       ( '&&' equality )*
/// equality        := relational     ( ('=='|'!='|'==='|'!==') relational )*
/// relational      := additive       ( ('>='|'<='|'>'|'<') additive )*
/// additive        := multiplicative ( ('+'|'-') multiplicative )*
/// multiplicative  := unary          ( ('*'|'/'|'%') unary )*
/// unary           := ('!'|'-'|'+')? primary
/// primary         := NUMBER | STRING | 'true' | 'false' | 'null'
///                  | IDENT ( '.' IDENT )* | '(' expression ')'
/// ```
///
/// Binary operators are left associative and follow the usual JS precedence, so
/// `a || b && c` is `a || (b && c)` and grouping parentheses are honoured. Both
/// sides of any operator can be a literal or a variable, so `5 > qty` and
/// `qty > min_qty` parse just as well as `qty > 5`.
class JsExpressionParser {
  final String expression;

  /// Binds the identifiers found in [expression] to actual values. Identifiers
  /// it does not know read as `null`.
  final JsVariableResolver? resolveVariable;

  final List<JsToken> _tokens;

  /// Resolved once per identifier, so the same name always yields the same
  /// [JsVariable] instance and can be reported only once.
  final Map<String, JsVariable?> _variables = {};
  int _index = 0;

  JsExpressionParser(this.expression, {this.resolveVariable})
    : _tokens = JsExpressionLexer(expression).tokenize();

  /// Parses [expression] into a syntax tree.
  ///
  /// Throws a [JsExpressionException] when the expression uses something
  /// outside the supported subset, so a malformed expression is reported
  /// instead of silently evaluating to a wrong value.
  static JsNode parseExpression(
    String expression, {
    JsVariableResolver? resolveVariable,
  }) =>
      JsExpressionParser(expression, resolveVariable: resolveVariable).parse();

  JsNode parse() {
    if (_current.isEof) throw _error('Empty expression', _current);
    final node = _parseOr();
    if (!_current.isEof) {
      throw _error('Unexpected "${_current.lexeme}"', _current);
    }
    return node;
  }

  JsNode _parseOr() {
    var left = _parseAnd();
    while (_current.isOperator(JsLogicalOperator.or.symbol)) {
      _advance();
      left = JsLogicalNode(
        operator: JsLogicalOperator.or,
        left: left,
        right: _parseAnd(),
      );
    }
    return left;
  }

  JsNode _parseAnd() {
    var left = _parseEquality();
    while (_current.isOperator(JsLogicalOperator.and.symbol)) {
      _advance();
      left = JsLogicalNode(
        operator: JsLogicalOperator.and,
        left: left,
        right: _parseEquality(),
      );
    }
    return left;
  }

  JsNode _parseEquality() =>
      _parseComparison(JsComparisonOperator.equalitySymbols, _parseRelational);

  JsNode _parseRelational() =>
      _parseComparison(JsComparisonOperator.relationalSymbols, _parseAdditive);

  JsNode _parseComparison(
    List<String> symbols,
    JsNode Function() parseOperand,
  ) {
    var left = parseOperand();
    while (_current.isAnyOperator(symbols)) {
      final operator = JsComparisonOperator.valueOf(_current.lexeme);
      if (operator == null) throw _error('Unknown operator', _current);
      _advance();
      left = JsComparisonNode(
        operator: operator,
        left: left,
        right: parseOperand(),
      );
    }
    return left;
  }

  JsNode _parseAdditive() => _parseArithmetic(
    JsArithmeticOperator.additiveSymbols,
    _parseMultiplicative,
  );

  JsNode _parseMultiplicative() =>
      _parseArithmetic(JsArithmeticOperator.multiplicativeSymbols, _parseUnary);

  JsNode _parseArithmetic(
    List<String> symbols,
    JsNode Function() parseOperand,
  ) {
    var left = parseOperand();
    while (_current.isAnyOperator(symbols)) {
      final operator = JsArithmeticOperator.valueOf(_current.lexeme);
      if (operator == null) throw _error('Unknown operator', _current);
      _advance();
      left = JsArithmeticNode(
        operator: operator,
        left: left,
        right: parseOperand(),
      );
    }
    return left;
  }

  JsNode _parseUnary() {
    if (_current.isAnyOperator(JsUnaryOperator.symbols)) {
      final operator = JsUnaryOperator.valueOf(_current.lexeme);
      if (operator == null) throw _error('Unknown operator', _current);
      _advance();
      return JsUnaryNode(operator: operator, operand: _parseUnary());
    }
    return _parsePrimary();
  }

  JsNode _parsePrimary() {
    final token = _current;
    switch (token.type) {
      case JsTokenType.number:
      case JsTokenType.string:
      case JsTokenType.boolean:
        _advance();
        return JsLiteralNode(token.value);
      case JsTokenType.nullLiteral:
        _advance();
        return const JsLiteralNode(null);
      case JsTokenType.identifier:
        _advance();
        return JsVariableNode(
          name: token.lexeme,
          variable: _variables.putIfAbsent(
            token.lexeme,
            () => resolveVariable?.call(token.lexeme),
          ),
        );
      case JsTokenType.openParen:
        _advance();
        final node = _parseOr();
        if (_current.type != JsTokenType.closeParen) {
          throw _error('Expected ")"', _current);
        }
        _advance();
        return node;
      case JsTokenType.closeParen:
      case JsTokenType.operator:
      case JsTokenType.eof:
        throw _error(
          token.isEof
              ? 'Unexpected end of expression'
              : 'Unexpected "${token.lexeme}"',
          token,
        );
    }
  }

  JsToken get _current => _tokens[_index];

  void _advance() {
    if (_index < _tokens.length - 1) ++_index;
  }

  JsExpressionException _error(String message, JsToken token) =>
      JsExpressionException(
        message,
        expression: expression,
        position: token.position,
      );
}
