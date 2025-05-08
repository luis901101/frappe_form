import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/entity/enumerator/field_type.dart';
import 'package:flutter/foundation.dart';

class DocFieldGroupController {
  const DocFieldGroupController();

  List<DocField> generateGroups(List<DocField> fields) {
    List<DocField> parentGroups = [];
    try {
      List<int> parentGroupIndexes = [];

      // Get the indexes of the parent groups which would be the Tabs fields
      for (int i = 0; i < fields.length; ++i) {
        if (fields[i].isParentGroupType) {
          parentGroupIndexes.add(i);
        }
      }

      // If no Tab fields are found, then just create a pseudo Tab group to make
      // all the fields grouped in a single group
      if (parentGroupIndexes.isEmpty) {
        parentGroups.add(DocField(
          // No name nor label as this is a pseudo field
          // fieldName: '',
          // label: '',
          type: FieldType.tabBreak,
          children: fields,
        ));
      } else {
        // Otherwise create a parent group for each Tab field including all the fields
        // in between
        for (int i = 0; i < parentGroupIndexes.length; ++i) {
          final parentGroupIndex = parentGroupIndexes[i];
          final nextParentGroupIndex = i + 1 < parentGroupIndexes.length
              ? parentGroupIndexes[i + 1]
              : fields.length;
          final parentGroupField = fields[parentGroupIndex];
          final groupFields =
              fields.sublist(parentGroupIndex + 1, nextParentGroupIndex);
          parentGroups.add(parentGroupField.copyWith(
            children: groupFields,
          ));
        }
      }

      for (final parentGroup in parentGroups) {
        List<DocField> childGroups = [];
        for (int i = 0; i < parentGroup.children.length; ++i) {
          final field = parentGroup.children[i];

          List<DocField> fieldsOfGroup = extractFieldsOfGroup(
            fields: parentGroup.children,
            groupType: field.isGroupType ? field.type : null,
            groupIndex: i,
          );

          // Case where there is a Column at the beginning of some Section
          if (fieldsOfGroup.isNotEmpty &&
              fieldsOfGroup.last.type == FieldType.columnBreak) {
            final fieldGroup = fieldsOfGroup.last;
            fieldGroup.children.addAll(extractFieldsOfGroup(
              fields: parentGroup.children,
              groupType: fieldGroup.type,
              groupIndex: i + fieldsOfGroup.length,
            ));
          }

          // Case where there is another Column after a Section Group has been created
          // This Column should be added to the last Section Group
          if (field.type == FieldType.columnBreak &&
              childGroups.isNotEmpty &&
              childGroups.last.type == FieldType.sectionBreak) {
            childGroups.last.children.add(generateGroup(
              field: field,
              fields: fieldsOfGroup,
            ));
          } else {
            childGroups.add(generateGroup(
              field: field,
              fields: fieldsOfGroup,
            ));
          }

          // Finds the deepest field in the already created child tree groups to
          // get the correct index in the plain list of fields, so we can continue
          // adding the rest of the fields in the correct order.
          final lastField = _deepestField(childGroups.lastOrNull);
          int indexOfLastField = _indexOfField(lastField, parentGroup.children);
          i = indexOfLastField > i ? indexOfLastField : i;
        }
        if (childGroups.isNotEmpty) {
          parentGroup.children.clear();
          parentGroup.children.addAll(childGroups);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return parentGroups;
  }

  // int _lengthOfGroup(List<DocField> fields) {
  //   int length = 0;
  //   for (final field in fields) {
  //     if (field.isGroupType) {
  //       length += 1 + _lengthOfGroup(field.children);
  //     } else {
  //       ++length;
  //     }
  //   }
  //   return length;
  // }

  int _indexOfField(DocField? field, List<DocField> fields) {
    if (field == null || fields.isEmpty) return -1;
    for (int i = 0; i < fields.length; ++i) {
      if (fields[i] == field) {
        return i;
      }
    }
    return -1;
  }

  DocField? _deepestField(DocField? field) {
    if (field == null) return null;
    if (field.children.isNotEmpty) {
      return _deepestField(field.children.last);
    }
    return field;
  }

  DocField generateGroup({
    required DocField field,
    required List<DocField> fields,
  }) {
    // If no fields then this is a single field group
    if (fields.isEmpty) return field;
    // If field is a group type, then we add the fields as children of the group
    if (field.isGroupType) {
      // If field is a Section Break, make sure all the children are Column Breaks
      if (field.type == FieldType.sectionBreak) {
        List<DocField> newSectionFields = [];
        DocField? tempColumn;
        for (final fieldChild in fields) {
          if (fieldChild.isGroupType) {
            if (tempColumn != null) {
              newSectionFields.add(tempColumn);
              tempColumn = null;
            }
            newSectionFields.add(fieldChild);
          } else {
            tempColumn ??= DocField(type: FieldType.columnBreak);
            tempColumn.children.add(fieldChild);
          }
        }
        if (tempColumn != null) {
          newSectionFields.add(tempColumn);
          tempColumn = null;
        }
        fields = newSectionFields;
      }

      return field.copyWith(children: fields);
    }
    // If field is not a group type, then this is assumed a section break
    // So we create a Dummy column break to hold the fields inside the section
    return DocField(
      type: FieldType.sectionBreak,
      children: [
        DocField(
          type: FieldType.columnBreak,
          children: fields,
        )
      ],
    );
  }

  /// Frappe Form fields are represented by a single level list of fields
  /// where grouping by Tabs, Columns, and Sections is done by using "breaks"
  /// which is a special type of field that indicates the start of a new group.
  List<DocField> extractFieldsOfGroup({
    /// The type of group to extract or null if should extract without filtering
    FieldType? groupType,

    /// The list of all the form fields to extract from
    required List<DocField> fields,

    /// The index of the group to extract from, this is only for optimization
    /// purposes, it's not required to be set.
    int groupIndex = 0,
  }) {
    List<DocField> fieldsOfGroup = [];
    for (int i = groupIndex; i < fields.length; ++i) {
      DocField field = fields[i];
      // If the current field type is groupType we are looking for, then start
      // searching for the group fields at the next index
      if (groupType == null || field.type == groupType) {
        for (int j = groupType == null ? i : i + 1; j < fields.length; ++j) {
          field = fields[j];
          // While the current field type is not a Group Type means it belongs
          // to the groupType we are searching, so we added to the list
          // otherwise we break the loop
          // There are special cases where a Group Type can have another
          // Group Type as a child, in that case add the field to the list and
          // break the loop immediately
          if (field.isGroupType) {
            if (groupType?.canHaveAsChild(field.type!) ?? false) {
              fieldsOfGroup.add(field);
            }
            break;
          }
          fieldsOfGroup.add(field);
        }
        break;
      }
    }
    return fieldsOfGroup;
  }
}
