import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/cupertino.dart';

class DocFieldDependsOnController {
  late final List<DocFieldDependsOnBundle> _dependsOnBundleList;
  late final DocFieldDependsOnBehavior _behavior;
  ValueChanged<bool>? _onEnabledChanged;

  DocFieldDependsOnController({
    required List<DocFieldDependsOnBundle>? dependsOnBundleList,
    String? behavior,
  })  : _dependsOnBundleList = dependsOnBundleList ?? [],
        _behavior = DocFieldDependsOnBehavior.valueOf(behavior) ??
            DocFieldDependsOnBehavior.defaultValue;

  bool init({required ValueChanged<bool> onEnabledChangedListener}) {
    _onEnabledChanged = onEnabledChangedListener;
    _addListeners();
    return checkIfEnabled();
  }

  void dispose() {
    _onEnabledChanged = null;
    _removeListeners();
  }

  void _onControllerChange() {
    checkIfEnabled();
  }

  bool checkIfEnabled({bool notify = true}) {
    bool enabled = _behavior.init();
    for (final dependsOnBundle in _dependsOnBundleList) {
      final controller = dependsOnBundle.controller;
      dynamic expectedValue = dependsOnBundle.expectedAnswer;
      List<dynamic> controllerValues = [];
      if (controller.rawValue is DocGeolocation) {
        final answerOption =
            jsonEncode((controller.rawValue as DocGeolocation).toJson());
        controllerValues = [answerOption];
      } else {
        // Any other possible controller value can be treated as dynamic
        controllerValues = [controller.rawValue];
      }

      if (controllerValues.isEmpty && expectedValue == null) {
        continue;
      }

      List<num>? controllerValuesAsNum = controllerValues
          .map((e) => NumUtils.tryParse(e?.toString()))
          .nonNulls
          .toList();
      num? expectedValueAsNum = NumUtils.tryParse(expectedValue?.toString());

      switch (dependsOnBundle.operator) {
        case DocFieldDependsOnOperator.equals:
          enabled = _behavior.check(
            enabled,
            controllerValues.firstWhereOrNull((controllerValue) =>
                    controllerValue?.toString() == expectedValue?.toString()) !=
                null,
          );
          break;
        case DocFieldDependsOnOperator.notEquals:
          enabled = _behavior.check(
            enabled,
            controllerValues.firstWhereOrNull((controllerValue) =>
                    controllerValue?.toString() != expectedValue?.toString()) !=
                null,
          );
          break;
        case DocFieldDependsOnOperator.greaterThan:
          enabled = _behavior.check(
            enabled,
            expectedValueAsNum != null &&
                controllerValuesAsNum.firstWhereOrNull(
                        (value) => value > expectedValueAsNum) !=
                    null,
          );
          break;
        case DocFieldDependsOnOperator.lessThan:
          enabled = _behavior.check(
            enabled,
            expectedValueAsNum != null &&
                controllerValuesAsNum.firstWhereOrNull(
                        (value) => value < expectedValueAsNum) !=
                    null,
          );
          break;
        case DocFieldDependsOnOperator.greaterOrEquals:
          enabled = _behavior.check(
            enabled,
            expectedValueAsNum != null &&
                controllerValuesAsNum.firstWhereOrNull(
                        (value) => value >= expectedValueAsNum) !=
                    null,
          );
          break;
        case DocFieldDependsOnOperator.lessOrEquals:
          enabled = _behavior.check(
            enabled,
            expectedValueAsNum != null &&
                controllerValuesAsNum.firstWhereOrNull(
                        (value) => value <= expectedValueAsNum) !=
                    null,
          );
          break;
      }
      if (enabled && _behavior.isAny) {
        break;
      }
    }
    if (notify) {
      _onEnabledChanged?.call(enabled);
    }
    return enabled;
  }

  void _addListeners() {
    for (final enableWhenBundle in _dependsOnBundleList) {
      enableWhenBundle.controller.addListener(_onControllerChange);
    }
  }

  void _removeListeners() {
    for (final enableWhenBundle in _dependsOnBundleList) {
      enableWhenBundle.controller.removeListener(_onControllerChange);
    }
  }
}
