import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_form/frappe_form.dart';

/// Evaluates [source] against a plain map of values, with no Frappe types
/// involved, which is the whole point of the analyzer living on its own.
dynamic evaluate(String source, [Map<String, dynamic> values = const {}]) =>
    JsExpression.parse(
      source,
      resolveVariable: JsConstantVariable.resolverOf(values),
    ).evaluate();

bool evaluateAsBool(String source, [Map<String, dynamic> values = const {}]) =>
    JsExpression.parse(
      source,
      resolveVariable: JsConstantVariable.resolverOf(values),
    ).evaluateAsBool();

void main() {
  group('precedence and grouping', () {
    const values = {'a': 1, 'b': 0, 'c': 1};

    test('&& binds tighter than ||', () {
      expect(evaluateAsBool('a == 1 || b == 1 && c == 1', values), isTrue);
      expect(evaluateAsBool('a == 0 || b == 1 && c == 1', values), isFalse);
      expect(evaluateAsBool('a == 0 || b == 0 && c == 1', values), isTrue);
    });

    test('parentheses override precedence', () {
      expect(evaluateAsBool('(a == 1 || b == 1) && c == 0', values), isFalse);
      expect(evaluateAsBool('(a == 1 || b == 1) && c == 1', values), isTrue);
    });

    test('* and / bind tighter than + and -', () {
      expect(evaluate('2 + 3 * 4'), 14);
      expect(evaluate('(2 + 3) * 4'), 20);
      expect(evaluate('10 - 2 - 3'), 5);
      expect(evaluate('100 / 10 / 2'), 5);
    });

    test('comparisons bind looser than arithmetic', () {
      expect(evaluateAsBool('2 + 3 > 4'), isTrue);
      expect(evaluateAsBool('2 + 3 > 5'), isFalse);
    });
  });

  group('operators', () {
    test('arithmetic', () {
      expect(evaluate('7 + 2'), 9);
      expect(evaluate('7 - 2'), 5);
      expect(evaluate('7 * 2'), 14);
      expect(evaluate('7 / 2'), 3.5);
      expect(evaluate('7 % 2'), 1);
      expect(evaluate('-7 % 2'), -1); // Sign follows the dividend, as in JS
    });

    test('unary', () {
      expect(evaluate('-3'), -3);
      expect(evaluate('+3'), 3);
      expect(evaluate('!0'), isTrue);
      expect(evaluate('!1'), isFalse);
      expect(evaluateAsBool('!flag', {'flag': ''}), isTrue);
    });

    test('loose comparison coerces, strict does not', () {
      expect(evaluateAsBool("'1' == 1"), isTrue);
      expect(evaluateAsBool("'1' === 1"), isFalse);
      expect(evaluateAsBool("'1' !== 1"), isTrue);
      expect(evaluateAsBool("'1' === '1'"), isTrue);
      expect(evaluateAsBool('null == null'), isTrue);
      expect(evaluateAsBool('null == 0'), isFalse);
    });

    test('relational falls back to string comparison', () {
      expect(evaluateAsBool("'Open' > 'Closed'"), isTrue);
      expect(evaluateAsBool("'Open' < 'Closed'"), isFalse);
      // Not comparable at all, the JS NaN case
      expect(evaluateAsBool("'Open' > 5"), isFalse);
      expect(evaluateAsBool("'Open' <= 5"), isFalse);
    });

    test('+ concatenates only when the operands are not numeric', () {
      expect(evaluate("'1' + '1'"), 2);
      expect(evaluate("'a' + 'b'"), 'ab');
      expect(evaluate("'total: ' + 5"), 'total: 5');
    });
  });

  group('literals and truthiness', () {
    test('literal kinds', () {
      expect(evaluate('1'), 1);
      expect(evaluate('2.5'), 2.5);
      expect(evaluate("'text'"), 'text');
      expect(evaluate('"text"'), 'text');
      expect(evaluate('true'), isTrue);
      expect(evaluate('false'), isFalse);
      expect(evaluate('null'), isNull);
      expect(evaluate('undefined'), isNull);
    });

    test('operator symbols inside a string stay in the string', () {
      expect(evaluate('"2025-01-01"'), '2025-01-01');
      expect(evaluate('"a/b"'), 'a/b');
      expect(evaluate('"A && B"'), 'A && B');
      expect(evaluate(r'''"O'Brien"'''), "O'Brien");
    });

    test('JS truthiness', () {
      expect(evaluateAsBool('0'), isFalse);
      expect(evaluateAsBool('1'), isTrue);
      expect(evaluateAsBool("''"), isFalse);
      expect(evaluateAsBool("'x'"), isTrue);
      expect(evaluateAsBool('null'), isFalse);
      expect(evaluateAsBool('false'), isFalse);
    });
  });

  group('variables', () {
    test('an unresolved identifier reads as null', () {
      expect(evaluate('missing'), isNull);
      expect(evaluateAsBool('missing == 1'), isFalse);
      expect(evaluateAsBool('missing == null'), isTrue);
    });

    test('dotted names are a single identifier', () {
      final expression = JsExpression.parse(
        'doc.check_1 == 1',
        resolveVariable: JsConstantVariable.resolverOf({'doc.check_1': 1}),
      );
      expect(expression.evaluateAsBool(), isTrue);
      expect(expression.variables.single.name, 'doc.check_1');
    });

    test('a name used several times is reported once', () {
      final expression = JsExpression.parse(
        'a > 1 && a < 5 && b == 2',
        resolveVariable: JsConstantVariable.resolverOf({'a': 3, 'b': 2}),
      );
      expect(expression.variables.length, 2);
      expect(expression.variables.map((variable) => variable.name), ['a', 'b']);
      expect(expression.evaluateAsBool(), isTrue);
    });

    test('values are read at evaluation time, not at parse time', () {
      final values = <String, dynamic>{'qty': 1};
      final expression = JsExpression.parse(
        'qty > 5',
        resolveVariable: (name) => _MapVariable(name, values),
      );
      expect(expression.evaluateAsBool(), isFalse);
      values['qty'] = 10;
      expect(expression.evaluateAsBool(), isTrue);
    });
  });

  group('errors', () {
    test('anything outside the supported subset is reported', () {
      for (final source in [
        'a ==',
        '((a == 1',
        'a == 1)',
        'in_list(["A"], a)',
        '[1, 2]',
        'a = 1',
        '',
      ]) {
        expect(
          () => JsExpression.parse(source),
          throwsA(isA<JsExpressionException>()),
          reason: source,
        );
      }
    });

    test('the exception points at the offending position', () {
      try {
        JsExpression.parse('a == 1)');
        fail('should have thrown');
      } on JsExpressionException catch (e) {
        expect(e.position, 6);
        expect(e.expression, 'a == 1)');
        expect(e.toString(), contains('Unexpected ")"'));
      }
    });

    test('tryParse returns null instead of throwing', () {
      expect(JsExpression.tryParse('a =='), isNull);
      expect(JsExpression.tryParse(null), isNull);
      expect(JsExpression.tryParse('   '), isNull);
      expect(JsExpression.tryParse('a == 1'), isNotNull);
    });
  });
}

/// A variable reading from a map that can change between evaluations.
class _MapVariable implements JsVariable {
  @override
  final String name;
  final Map<String, dynamic> values;

  const _MapVariable(this.name, this.values);

  @override
  dynamic get value => values[name];
}
