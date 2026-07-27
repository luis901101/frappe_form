import 'package:frappe_form/src/entity/doc_geolocation.dart';
import 'package:frappe_form/src/entity/enumerator/field_type.dart';
import 'package:frappe_form/src/js_expression/js_variable.dart';
import 'package:frappe_form/src/logic/utils/date_utils.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:frappe_form/src/model/doc_field_bundle.dart';

/// Exposes the current value of a form field to a JS expression, so the
/// depends-on properties of a DocField can be evaluated against the form.
class DocFieldVariable implements JsVariable {
  /// The prefix Frappe uses to reference the current document fields, which is
  /// optional, both `doc.check_1` and `check_1` reference the same field.
  static const String docPrefix = 'doc.';

  /// The field name, without the [docPrefix].
  @override
  final String name;

  /// The controller holding the field value.
  final FieldController controller;

  /// Used to read an untouched field as the Frappe default of its type.
  final FieldType fieldType;

  const DocFieldVariable({
    required this.name,
    required this.controller,
    required this.fieldType,
  });

  /// Builds the resolver a JS expression uses to bind its identifiers to the
  /// fields of [itemBundles]. Unknown names resolve to `null` and read as
  /// `null` in the expression.
  static JsVariableResolver resolverOf(List<DocFieldBundle> itemBundles) =>
      (name) {
        final fieldName = name.startsWith(docPrefix)
            ? name.substring(docPrefix.length)
            : name;
        final itemBundle = findBundle(fieldName, itemBundles);
        return itemBundle == null
            ? null
            : DocFieldVariable(
                name: fieldName,
                controller: itemBundle.controller,
                fieldType: itemBundle.field.type,
              );
      };

  @override
  dynamic get value {
    final rawValue = controller.rawValue;
    return switch (rawValue) {
      null => defaultValue,
      DocGeolocation value => value.toJsonString(),
      DateTime value => switch (fieldType) {
        FieldType.date => value.toJsonDate(),
        FieldType.time => value.toJsonTime(),
        _ => value.toJsonDateTime(),
      },
      _ => rawValue,
    };
  }

  /// The value Frappe assumes for a field the user has not filled yet, so
  /// `doc.some_check == 0` holds for an untouched checkbox and an untouched
  /// number still contributes `0` to a sum.
  dynamic get defaultValue => switch (fieldType) {
    FieldType.check ||
    FieldType.int ||
    FieldType.float ||
    FieldType.currency ||
    FieldType.percent ||
    FieldType.rating ||
    FieldType.duration => 0,
    FieldType.data ||
    FieldType.smallText ||
    FieldType.longText ||
    FieldType.text ||
    FieldType.select ||
    FieldType.autocomplete ||
    FieldType.password ||
    FieldType.phone ||
    FieldType.textEditor ||
    FieldType.htmlEditor ||
    FieldType.markdownEditor ||
    FieldType.code ||
    FieldType.color ||
    FieldType.barcode ||
    FieldType.link ||
    FieldType.dynamicLink ||
    FieldType.readOnly ||
    FieldType.signature ||
    FieldType.attach ||
    FieldType.attachImage => '',
    _ => null,
  };

  /// Depth first search of the form field named [fieldName], walking both the
  /// grouping children and the children a view builds by itself.
  static DocFieldBundle? findBundle(
    String fieldName,
    List<DocFieldBundle> itemBundles,
  ) {
    for (final item in itemBundles) {
      if (item.field.fieldName == fieldName) return item;
      final result = findBundle(fieldName, [
        ...item.children,
        ...item.view.childrenBundles,
      ]);
      if (result != null) return result;
    }
    return null;
  }

  @override
  String toString() => '$docPrefix$name';
}
