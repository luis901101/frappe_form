import 'package:collection/collection.dart';

enum DocFieldDependsOnBehavior {
  /// Enable the question when all the dependsOn criteria are satisfied.
  all,

  /// Enable the question when any of the dependsOn criteria are satisfied.
  any,
  ;

  static const defaultValue = any;

  bool get isAny => this == any;

  bool init() => this == all;
  bool check(bool currentValue, bool newValue) =>
      isAny ? currentValue || newValue : currentValue && newValue;

  static DocFieldDependsOnBehavior? valueOf(String? name) =>
      DocFieldDependsOnBehavior.values
          .firstWhereOrNull((value) => value.name == name);
}
