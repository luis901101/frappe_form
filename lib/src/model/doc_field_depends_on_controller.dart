import 'package:flutter/cupertino.dart';
import 'package:frappe_form/src/model/doc_field_depends_on_bundle.dart';

/// Holds the three depends-on rules of a field and keeps their results in sync
/// with the fields they reference.
class DocFieldDependsOnController {
  DocFieldDependsOnBundle? _requiredDependsOn;
  DocFieldDependsOnBundle? _readOnlyDependsOn;
  DocFieldDependsOnBundle? _visibilityDependsOn;
  ValueChanged<bool>? _onRequiredDependsOnChanged;
  ValueChanged<bool>? _onReadOnlyDependsOnChanged;
  ValueChanged<bool>? _onVisibilityDependsOnChanged;

  DocFieldDependsOnController({
    DocFieldDependsOnBundle? requiredDependsOn,
    DocFieldDependsOnBundle? readOnlyDependsOn,
    DocFieldDependsOnBundle? visibilityDependsOn,
  }) : _requiredDependsOn = requiredDependsOn,
       _readOnlyDependsOn = readOnlyDependsOn,
       _visibilityDependsOn = visibilityDependsOn;

  DocFieldDependsOnBundle? get requiredDependsOn => _requiredDependsOn;
  DocFieldDependsOnBundle? get readOnlyDependsOn => _readOnlyDependsOn;
  DocFieldDependsOnBundle? get visibilityDependsOn => _visibilityDependsOn;

  /// Replacing a bundle detaches the listener from the previous one, so
  /// rebuilding the form does not leave stale listeners behind on the fields
  /// the old expression referenced.
  set requiredDependsOn(DocFieldDependsOnBundle? value) {
    if (identical(_requiredDependsOn, value)) return;
    _requiredDependsOn?.removeListener(checkIfRequired);
    _requiredDependsOn = value;
    if (_onRequiredDependsOnChanged != null) {
      value?.addListener(checkIfRequired);
    }
  }

  set readOnlyDependsOn(DocFieldDependsOnBundle? value) {
    if (identical(_readOnlyDependsOn, value)) return;
    _readOnlyDependsOn?.removeListener(checkIfReadOnly);
    _readOnlyDependsOn = value;
    if (_onReadOnlyDependsOnChanged != null) {
      value?.addListener(checkIfReadOnly);
    }
  }

  set visibilityDependsOn(DocFieldDependsOnBundle? value) {
    if (identical(_visibilityDependsOn, value)) return;
    _visibilityDependsOn?.removeListener(checkIfVisible);
    _visibilityDependsOn = value;
    if (_onVisibilityDependsOnChanged != null) {
      value?.addListener(checkIfVisible);
    }
  }

  bool listenOnRequiredDependsOnChangesAndCheck(ValueChanged<bool>? listener) {
    _onRequiredDependsOnChanged = listener;
    _requiredDependsOn?.removeListener(checkIfRequired);
    _requiredDependsOn?.addListener(checkIfRequired);
    return checkIfRequired();
  }

  bool listenOnReadOnlyDependsOnChangesAndCheck(ValueChanged<bool>? listener) {
    _onReadOnlyDependsOnChanged = listener;
    _readOnlyDependsOn?.removeListener(checkIfReadOnly);
    _readOnlyDependsOn?.addListener(checkIfReadOnly);
    return checkIfReadOnly();
  }

  bool listenOnVisibilityDependsOnChangesAndCheck(
    ValueChanged<bool>? listener,
  ) {
    _onVisibilityDependsOnChanged = listener;
    _visibilityDependsOn?.removeListener(checkIfVisible);
    _visibilityDependsOn?.addListener(checkIfVisible);
    return checkIfVisible();
  }

  bool checkIfRequired({bool notify = true}) {
    bool result = _requiredDependsOn?.check() ?? false;
    if (notify) {
      _onRequiredDependsOnChanged?.call(result);
    }
    return result;
  }

  bool checkIfReadOnly({bool notify = true}) {
    bool result = _readOnlyDependsOn?.check() ?? false;
    if (notify) {
      _onReadOnlyDependsOnChanged?.call(result);
    }
    return result;
  }

  bool checkIfVisible({bool notify = true}) {
    bool result = _visibilityDependsOn?.check() ?? true;
    if (notify) {
      _onVisibilityDependsOnChanged?.call(result);
    }
    return result;
  }

  void _removeListeners() {
    _requiredDependsOn?.removeListener(checkIfRequired);
    _readOnlyDependsOn?.removeListener(checkIfReadOnly);
    _visibilityDependsOn?.removeListener(checkIfVisible);
  }

  void dispose() {
    _onRequiredDependsOnChanged = null;
    _onReadOnlyDependsOnChanged = null;
    _onVisibilityDependsOnChanged = null;
    _removeListeners();
  }
}
