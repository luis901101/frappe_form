import 'package:collection/collection.dart';

enum DocFieldDependsOnCondition {
  and('&&'),
  or('||'),
  ;

  final String name;
  const DocFieldDependsOnCondition(this.name);

  static DocFieldDependsOnCondition? valueOf(String? name) =>
      DocFieldDependsOnCondition.values
          .firstWhereOrNull((value) => value.name == name);
}
