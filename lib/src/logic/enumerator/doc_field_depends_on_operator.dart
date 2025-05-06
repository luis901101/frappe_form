import 'package:collection/collection.dart';

enum DocFieldDependsOnOperator {
  /// True if whether at least one answer has a value that is equal to the dependsOn answer.
  equals('=='),

  /// True if whether at least no answer has a value that is equal to the dependsOn answer.
  notEquals('!='),

  /// True if whether at least no answer has a value that is greater than the dependsOn answer.
  greaterThan('>'),

  /// True if whether at least no answer has a value that is less than the dependsOn answer.
  lessThan('<'),

  /// True if whether at least no answer has a value that is greater or equal to the dependsOn answer.
  greaterOrEquals('>='),

  /// True if whether at least no answer has a value that is less or equal to the dependsOn answer.
  lessOrEquals('<='),
  ;

  final String name;
  const DocFieldDependsOnOperator(this.name);

  static DocFieldDependsOnOperator? valueOf(String? name) =>
      DocFieldDependsOnOperator.values
          .firstWhereOrNull((value) => value.name == name);
}
