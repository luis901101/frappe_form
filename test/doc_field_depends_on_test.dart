import 'package:flutter_test/flutter_test.dart';
import 'package:frappe_form/frappe_form.dart';

/// Builds a form field bundle backed by [controller].
///
/// The view is only needed so the field lookup can walk `view.childrenBundles`,
/// any concrete [DocFieldView] does the job, the controller passed to the
/// bundle is the one the expressions are evaluated against.
DocFieldBundle bundleOf(
  String fieldName,
  FieldType type,
  FieldController controller,
) {
  final field = DocField(fieldName: fieldName, type: type);
  return DocFieldBundle(
    field: field,
    controller: controller,
    view: DocFieldDataView(field: field),
  );
}

/// A `Check` field, `null` when the user never touched it.
DocFieldBundle checkBundle(String fieldName, [int? value]) => bundleOf(
  fieldName,
  FieldType.check,
  CustomValueController<int>(value: value),
);

/// A text backed field, the shape `Data`, `Int`, `Float`, `Currency` and
/// `Percent` fields really use.
DocFieldBundle textBundle(
  String fieldName, {
  String text = '',
  FieldType type = FieldType.data,
}) => bundleOf(fieldName, type, CustomTextEditingController(text: text));

/// A value backed field, the shape `Select` and `Date` fields really use.
DocFieldBundle valueBundle<T>(
  String fieldName, {
  T? value,
  FieldType type = FieldType.select,
}) => bundleOf(fieldName, type, CustomValueController<T>(value: value));

/// Parses and evaluates [expression], returning `null` when it could not be
/// parsed at all.
bool? evaluate(String expression, List<DocFieldBundle> bundles) =>
    DocFieldDependsOnBundle.fromExpression(expression, bundles)?.check();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('reported expression', () {
    const expression =
        'eval: ((doc.s_check_1==1 || doc.s_check_2==1 || doc.s_check_3==1) '
        '&& doc.some_check_none==0)';

    test('holds for every combination of the four checks', () {
      for (int mask = 0; mask < 16; ++mask) {
        final check1 = (mask & 1) != 0 ? 1 : 0;
        final check2 = (mask & 2) != 0 ? 1 : 0;
        final check3 = (mask & 4) != 0 ? 1 : 0;
        final none = (mask & 8) != 0 ? 1 : 0;
        final bundles = [
          checkBundle('s_check_1', check1),
          checkBundle('s_check_2', check2),
          checkBundle('s_check_3', check3),
          checkBundle('some_check_none', none),
        ];
        final expected =
            (check1 == 1 || check2 == 1 || check3 == 1) && none == 0;
        expect(
          evaluate(expression, bundles),
          expected,
          reason:
              's_check_1=$check1, s_check_2=$check2, '
              's_check_3=$check3, some_check_none=$none',
        );
      }
    });

    test('depends on the four checks, including the first one', () {
      final bundles = [
        checkBundle('s_check_1'),
        checkBundle('s_check_2'),
        checkBundle('s_check_3'),
        checkBundle('some_check_none'),
      ];
      final dependsOn = DocFieldDependsOnBundle.fromExpression(
        expression,
        bundles,
      );
      expect(dependsOn, isNotNull);
      expect(dependsOn!.dependencyControllers.length, 4);
      for (final bundle in bundles) {
        expect(dependsOn.dependencyControllers, contains(bundle.controller));
      }
    });

    test('re-evaluates when a referenced field changes', () {
      final check1 = CustomValueController<int>(value: 0);
      final bundles = [
        bundleOf('s_check_1', FieldType.check, check1),
        checkBundle('s_check_2', 0),
        checkBundle('s_check_3', 0),
        checkBundle('some_check_none', 0),
      ];
      final dependsOn = DocFieldDependsOnBundle.fromExpression(
        expression,
        bundles,
      )!;
      int notifications = 0;
      void onChanged() => ++notifications;
      dependsOn.addListener(onChanged);

      expect(dependsOn.check(), isFalse);
      check1.value = 1;
      expect(notifications, 1);
      expect(dependsOn.check(), isTrue);

      dependsOn.removeListener(onChanged);
      check1.value = 0;
      expect(notifications, 1);
    });
  });

  group('operator precedence and grouping', () {
    List<DocFieldBundle> bundles(int a, int b, int c) => [
      checkBundle('a', a),
      checkBundle('b', b),
      checkBundle('c', c),
    ];

    test('&& binds tighter than ||', () {
      // a || (b && c)
      const expression = 'eval:doc.a==1 || doc.b==1 && doc.c==1';
      expect(evaluate(expression, bundles(1, 0, 0)), isTrue);
      expect(evaluate(expression, bundles(0, 1, 0)), isFalse);
      expect(evaluate(expression, bundles(0, 1, 1)), isTrue);
      expect(evaluate(expression, bundles(0, 0, 1)), isFalse);
    });

    test('parentheses override precedence', () {
      // (a || b) && c
      const expression = 'eval:(doc.a==1 || doc.b==1) && doc.c==1';
      expect(evaluate(expression, bundles(1, 0, 0)), isFalse);
      expect(evaluate(expression, bundles(1, 0, 1)), isTrue);
      expect(evaluate(expression, bundles(0, 1, 1)), isTrue);
      expect(evaluate(expression, bundles(0, 0, 1)), isFalse);
    });

    test('redundant and deeply nested parentheses are honoured', () {
      const expression = 'eval:(((doc.a==1)) && ((doc.b==1 || (doc.c==1))))';
      expect(evaluate(expression, bundles(1, 0, 1)), isTrue);
      expect(evaluate(expression, bundles(1, 0, 0)), isFalse);
      expect(evaluate(expression, bundles(0, 1, 1)), isFalse);
    });

    test('chained && keeps every operand', () {
      const expression = 'eval:doc.a==1 && doc.b==1 && doc.c==1';
      expect(evaluate(expression, bundles(1, 1, 1)), isTrue);
      expect(evaluate(expression, bundles(1, 1, 0)), isFalse);
      expect(evaluate(expression, bundles(0, 1, 1)), isFalse);
    });

    test('chained || keeps every operand', () {
      const expression = 'eval:doc.a==1 || doc.b==1 || doc.c==1';
      expect(evaluate(expression, bundles(0, 0, 0)), isFalse);
      expect(evaluate(expression, bundles(1, 0, 0)), isTrue);
      expect(evaluate(expression, bundles(0, 0, 1)), isTrue);
    });
  });

  group('comparison operators', () {
    List<DocFieldBundle> bundles = [
      textBundle('qty', text: '10', type: FieldType.int),
      textBundle('min_qty', text: '4', type: FieldType.int),
      textBundle('status', text: 'Open'),
    ];

    test('field on the left, literal on the right', () {
      expect(evaluate('eval:doc.qty == 10', bundles), isTrue);
      expect(evaluate('eval:doc.qty != 10', bundles), isFalse);
      expect(evaluate('eval:doc.qty > 9', bundles), isTrue);
      expect(evaluate('eval:doc.qty >= 10', bundles), isTrue);
      expect(evaluate('eval:doc.qty < 10', bundles), isFalse);
      expect(evaluate('eval:doc.qty <= 10', bundles), isTrue);
      expect(evaluate("eval:doc.status == 'Open'", bundles), isTrue);
      expect(evaluate('eval:doc.status == "Closed"', bundles), isFalse);
    });

    test('literal on the left, field on the right', () {
      expect(evaluate('eval:10 == doc.qty', bundles), isTrue);
      expect(evaluate('eval:9 < doc.qty', bundles), isTrue);
      expect(evaluate('eval:9 > doc.qty', bundles), isFalse);
      expect(evaluate("eval:'Open' == doc.status", bundles), isTrue);
    });

    test('field compared against another field', () {
      expect(evaluate('eval:doc.qty > doc.min_qty', bundles), isTrue);
      expect(evaluate('eval:doc.min_qty > doc.qty', bundles), isFalse);
      expect(evaluate('eval:doc.qty == doc.qty', bundles), isTrue);
      expect(evaluate('eval:doc.qty != doc.min_qty', bundles), isTrue);
    });

    test('non numeric operands compare as strings', () {
      expect(evaluate("eval:doc.status > 'Closed'", bundles), isTrue);
      expect(evaluate("eval:doc.status < 'Closed'", bundles), isFalse);
    });

    test('incomparable operands are false for every relational operator', () {
      expect(evaluate('eval:doc.status > 5', bundles), isFalse);
      expect(evaluate('eval:doc.status < 5', bundles), isFalse);
      expect(evaluate('eval:doc.status >= 5', bundles), isFalse);
      expect(evaluate('eval:doc.status <= 5', bundles), isFalse);
    });
  });

  group('arithmetic', () {
    List<DocFieldBundle> bundles = [
      textBundle('a', text: '6', type: FieldType.int),
      textBundle('b', text: '4', type: FieldType.int),
      textBundle('c', text: '2', type: FieldType.int),
    ];

    test('every operator', () {
      expect(evaluate('eval:doc.a + doc.b == 10', bundles), isTrue);
      expect(evaluate('eval:doc.a - doc.b == 2', bundles), isTrue);
      expect(evaluate('eval:doc.a * doc.b == 24', bundles), isTrue);
      expect(evaluate('eval:doc.a / doc.c == 3', bundles), isTrue);
      expect(evaluate('eval:doc.a % doc.b == 2', bundles), isTrue);
    });

    test('operand order is preserved for - and /', () {
      expect(evaluate('eval:doc.b - doc.a == -2', bundles), isTrue);
      expect(evaluate('eval:doc.c / doc.a < 1', bundles), isTrue);
    });

    test('* and / bind tighter than + and -', () {
      // 6 + (4 * 2) == 14
      expect(evaluate('eval:doc.a + doc.b * doc.c == 14', bundles), isTrue);
      expect(evaluate('eval:doc.a + doc.b * doc.c == 20', bundles), isFalse);
    });

    test('parentheses override arithmetic precedence', () {
      // (6 + 4) * 2 == 20
      expect(evaluate('eval:(doc.a + doc.b) * doc.c == 20', bundles), isTrue);
    });

    test('chained + - keeps every operand', () {
      expect(evaluate('eval:doc.a + doc.b - doc.c == 8', bundles), isTrue);
    });

    test('mixes with logical operators without losing either side', () {
      final mixed = [
        ...bundles,
        checkBundle('flag', 1),
        checkBundle('other_flag', 0),
      ];
      expect(
        evaluate('eval:doc.a + doc.b >= 10 && doc.flag == 1', mixed),
        isTrue,
      );
      expect(
        evaluate('eval:doc.a + doc.b >= 11 && doc.flag == 1', mixed),
        isFalse,
      );
      expect(
        evaluate('eval:doc.a + doc.b >= 11 || doc.flag == 1', mixed),
        isTrue,
      );
      expect(
        evaluate('eval:doc.other_flag == 1 && doc.a + doc.b >= 10', mixed),
        isFalse,
      );
    });

    test('literals can take part in arithmetic', () {
      expect(evaluate('eval:doc.a + 5 > 10', bundles), isTrue);
      expect(evaluate('eval:doc.a + 5 > 11', bundles), isFalse);
      expect(evaluate('eval:2 * doc.a == 12', bundles), isTrue);
    });
  });

  group('literals', () {
    test('negative numbers are not mistaken for a subtraction', () {
      final bundles = [
        textBundle('a', text: '-1', type: FieldType.int),
        checkBundle('b', 2),
      ];
      expect(evaluate('eval:doc.a == -1', bundles), isTrue);
      expect(evaluate('eval:doc.a > -5 && doc.b == 2', bundles), isTrue);
      expect(evaluate('eval:doc.a < -5 && doc.b == 2', bundles), isFalse);
    });

    test('operator symbols inside a string are not operators', () {
      final bundles = [
        valueBundle<String>(
          'the_date',
          value: '2025-01-01',
          type: FieldType.data,
        ),
        textBundle('path', text: 'a/b'),
        textBundle('title', text: 'A && B'),
        textBundle('owner_name', text: "O'Brien"),
      ];
      expect(evaluate('eval:doc.the_date == "2025-01-01"', bundles), isTrue);
      expect(evaluate('eval:doc.the_date == "2025-01-02"', bundles), isFalse);
      expect(evaluate('eval:doc.path == "a/b"', bundles), isTrue);
      expect(evaluate('eval:doc.title == "A && B"', bundles), isTrue);
      expect(
        evaluate(r"""eval:doc.owner_name == "O'Brien" """, bundles),
        isTrue,
      );
    });

    test('boolean and null literals', () {
      final bundles = [
        checkBundle('flag', 1),
        checkBundle('untouched'),
        textBundle('name', text: 'Luis'),
      ];
      expect(evaluate('eval:doc.flag == true', bundles), isTrue);
      expect(evaluate('eval:doc.flag == false', bundles), isFalse);
      expect(evaluate('eval:doc.name != null', bundles), isTrue);
      // An untouched Check counts as 0, not as null.
      expect(evaluate('eval:doc.untouched == null', bundles), isFalse);
    });

    test('a two character operand is not split into field and value', () {
      final bundles = [textBundle('a', text: '10', type: FieldType.int)];
      expect(evaluate('eval:doc.a == 10', bundles), isTrue);
      expect(evaluate('eval:doc.a > 10', bundles), isFalse);
    });
  });

  group('truthiness', () {
    test('a bare field reference follows JS truthiness', () {
      expect(evaluate('eval:doc.qty', [checkBundle('qty', 0)]), isFalse);
      expect(evaluate('eval:doc.qty', [checkBundle('qty', 1)]), isTrue);
      expect(evaluate('eval:doc.qty', [checkBundle('qty')]), isFalse);
      expect(evaluate('eval:doc.qty', [textBundle('qty', text: '')]), isFalse);
      expect(
        evaluate('eval:doc.qty', [textBundle('qty', text: 'something')]),
        isTrue,
      );
    });

    test('the plain non eval form is supported', () {
      expect(evaluate('my_check', [checkBundle('my_check', 1)]), isTrue);
      expect(evaluate('my_check', [checkBundle('my_check', 0)]), isFalse);
      expect(evaluate('doc.my_check', [checkBundle('my_check', 1)]), isTrue);
    });

    test('negation', () {
      expect(evaluate('eval:!doc.flag', [checkBundle('flag', 0)]), isTrue);
      expect(evaluate('eval:!doc.flag', [checkBundle('flag', 1)]), isFalse);
    });
  });

  group('unset values follow the Frappe field defaults', () {
    test('an untouched Check equals 0', () {
      final bundles = [checkBundle('some_check')];
      expect(evaluate('eval:doc.some_check == 0', bundles), isTrue);
      expect(evaluate('eval:doc.some_check == 1', bundles), isFalse);
    });

    test('an untouched Check contributes 0 to a sum', () {
      final bundles = [
        checkBundle('check1', 1),
        checkBundle('check2', 1),
        checkBundle('check3', 1),
        checkBundle('check4'),
      ];
      expect(
        evaluate(
          'eval:doc.check1 + doc.check2 + doc.check3 + doc.check4 >= 3',
          bundles,
        ),
        isTrue,
      );
      expect(
        evaluate(
          'eval:doc.check1 + doc.check2 + doc.check3 + doc.check4 >= 4',
          bundles,
        ),
        isFalse,
      );
    });

    test('an untouched Select equals the empty string', () {
      final bundles = [valueBundle<String>('choice')];
      expect(evaluate("eval:doc.choice == ''", bundles), isTrue);
      expect(evaluate("eval:doc.choice == 'Option 3'", bundles), isFalse);
    });
  });

  group('date fields compare against the value Frappe stores', () {
    test('Date', () {
      final bundles = [
        valueBundle<DateTime>(
          'the_date',
          value: DateTime(2025, 1, 1),
          type: FieldType.date,
        ),
      ];
      expect(evaluate("eval:doc.the_date == '2025-01-01'", bundles), isTrue);
      expect(evaluate("eval:doc.the_date > '2024-12-31'", bundles), isTrue);
      expect(evaluate("eval:doc.the_date == '2025-01-02'", bundles), isFalse);
    });

    test('Time', () {
      final bundles = [
        valueBundle<DateTime>(
          'the_time',
          value: DateTime(2025, 1, 1, 10, 30),
          type: FieldType.time,
        ),
      ];
      expect(evaluate("eval:doc.the_time == '10:30:00'", bundles), isTrue);
    });
  });

  group('strict operators', () {
    test('=== and !== do not coerce', () {
      final bundles = [
        textBundle('text_one', text: '1'),
        checkBundle('num_one', 1),
      ];
      expect(evaluate('eval:doc.text_one == 1', bundles), isTrue);
      expect(evaluate('eval:doc.text_one === 1', bundles), isFalse);
      expect(evaluate('eval:doc.text_one !== 1', bundles), isTrue);
      expect(evaluate('eval:doc.num_one === 1', bundles), isTrue);
      expect(evaluate("eval:doc.text_one === '1'", bundles), isTrue);
    });
  });

  group('error handling', () {
    test('an unknown field name evaluates to false instead of throwing', () {
      final bundles = [checkBundle('a', 1)];
      expect(evaluate('eval:doc.does_not_exist == 1', bundles), isFalse);
      expect(
        evaluate('eval:doc.a == 1 && doc.does_not_exist == 1', bundles),
        isFalse,
      );
      expect(
        evaluate('eval:doc.a == 1 || doc.does_not_exist == 1', bundles),
        isTrue,
      );
    });

    test('a malformed expression yields no bundle at all', () {
      final bundles = [checkBundle('a', 1)];
      expect(
        DocFieldDependsOnBundle.fromExpression('eval:doc.a ==', bundles),
        isNull,
      );
      expect(
        DocFieldDependsOnBundle.fromExpression('eval:((doc.a==1', bundles),
        isNull,
      );
      expect(
        DocFieldDependsOnBundle.fromExpression('eval:doc.a == 1)', bundles),
        isNull,
      );
      expect(DocFieldDependsOnBundle.fromExpression('eval:', bundles), isNull);
      expect(DocFieldDependsOnBundle.fromExpression(null, bundles), isNull);
      expect(DocFieldDependsOnBundle.fromExpression('   ', bundles), isNull);
    });

    test('the parse exception reports what could not be read', () {
      expect(
        () => JsExpression.parse('doc.a =='),
        throwsA(isA<JsExpressionException>()),
      );
    });
  });

  group('dependency controllers', () {
    test('a field referenced twice registers a single controller', () {
      final bundles = [textBundle('a', text: '3', type: FieldType.int)];
      final dependsOn = DocFieldDependsOnBundle.fromExpression(
        'eval:doc.a > 1 && doc.a < 5',
        bundles,
      )!;
      expect(dependsOn.dependencyControllers.length, 1);
      expect(dependsOn.check(), isTrue);
    });

    test('an unknown field contributes no controller', () {
      final bundles = [checkBundle('a', 1)];
      final dependsOn = DocFieldDependsOnBundle.fromExpression(
        'eval:doc.a == 1 || doc.ghost == 1',
        bundles,
      )!;
      expect(dependsOn.dependencyControllers.length, 1);
    });
  });

  group('expressions used by the example form', () {
    test("doc.select=='Option 3'", () {
      final bundles = [valueBundle<String>('select', value: 'Option 3')];
      expect(evaluate("eval:doc.select=='Option 3'", bundles), isTrue);
      expect(evaluate("eval:doc.select=='Option 1'", bundles), isFalse);
    });

    test('check and select combined', () {
      const expression =
          "eval:doc.check_liked_option_3==1 && doc.select=='Option 3'";
      expect(
        evaluate(expression, [
          checkBundle('check_liked_option_3', 1),
          valueBundle<String>('select', value: 'Option 3'),
        ]),
        isTrue,
      );
      expect(
        evaluate(expression, [
          checkBundle('check_liked_option_3', 0),
          valueBundle<String>('select', value: 'Option 3'),
        ]),
        isFalse,
      );
      expect(
        evaluate(expression, [
          checkBundle('check_liked_option_3', 1),
          valueBundle<String>('select', value: 'Option 1'),
        ]),
        isFalse,
      );
    });

    test('none of the above', () {
      const expression =
          'eval:doc.none_of_the_above_check == 0 && doc.check_1 == 0 '
          '&& doc.check_2 == 0 && doc.check_3 == 0';
      expect(
        evaluate(expression, [
          checkBundle('none_of_the_above_check', 0),
          checkBundle('check_1', 0),
          checkBundle('check_2', 0),
          checkBundle('check_3', 0),
        ]),
        isTrue,
      );
      expect(
        evaluate(expression, [
          checkBundle('none_of_the_above_check', 0),
          checkBundle('check_1', 0),
          checkBundle('check_2', 1),
          checkBundle('check_3', 0),
        ]),
        isFalse,
      );
    });

    test('at least three of the other checks', () {
      const expression =
          'eval:doc.check2 + doc.check3 + doc.check4 + doc.check5 >= 3';
      List<DocFieldBundle> bundles(int c2, int c3, int c4, int c5) => [
        checkBundle('check2', c2),
        checkBundle('check3', c3),
        checkBundle('check4', c4),
        checkBundle('check5', c5),
      ];
      expect(evaluate(expression, bundles(1, 1, 1, 0)), isTrue);
      expect(evaluate(expression, bundles(1, 1, 0, 0)), isFalse);
      expect(evaluate(expression, bundles(1, 1, 1, 1)), isTrue);
    });
  });
}
