import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:frappe_form/frappe_form.dart';

class DocFormController {
  /// Allows to override the function to generate individual field answer,
  /// either to generate a new [DocFieldAnswer] or modify the generated one
  DocFieldAnswer Function(DocFieldBundle fieldBundle, dynamic fieldValue)?
      onGenerateFieldAnswer;

  /// Allows customizing the logic that maps [DocField] objects into
  /// [DocFieldView] widgets.
  ///
  /// [enableWhenController] needs to be passed to the returned [DocFieldView]
  /// otherwise the enableWhen functionality of for that DocField will not work.
  /// assuming that form item has enableWhen values
  DocFieldView? Function(
    DocField field,
    DocFieldDependsOnController? dependsOnController,
    Future<Attachment?> Function()? onAttachmentLoaded,
  )? onBuildFieldView;

  final DocFieldGroupController docFieldGroupController;
  DocFormController({
    this.docFieldGroupController = const DocFieldGroupController(),
    this.onGenerateFieldAnswer,
    this.onBuildFieldView,
  });

  List<DocFieldBundle> buildFormFields(DocForm form,
      {Future<Attachment?> Function()? onAttachmentLoaded}) {
    List<DocFieldBundle> fieldBundles = [];
    try {
      List<DocField> fieldGroups =
          docFieldGroupController.generateGroups(form.fields);
      fieldBundles = buildFormFieldBundles(
        fields: fieldGroups,
        onAttachmentLoaded: onAttachmentLoaded,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return fieldBundles;
  }

  List<DocFieldBundle> buildFormFieldBundles({
    required List<DocField> fields,
    required Future<Attachment?> Function()? onAttachmentLoaded,
    String? groupId,
    List<DocFieldBundle>? alreadyBuiltFieldBundles,
  }) {
    List<DocFieldBundle> fieldBundles = [];
    try {
      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];
        DocFieldDependsOnController? dependsOnController =
            getDependsOnController(item: field, itemBundles: [
          ...(alreadyBuiltFieldBundles ?? []),
          ...fieldBundles,
        ]);

        final fieldBundle = buildFormFieldBundle(
          field: field,
          enableWhenController: dependsOnController,
          onAttachmentLoaded: onAttachmentLoaded,
          groupId: groupId,
          alreadyBuiltItemBundles: [
            ...(alreadyBuiltFieldBundles ?? []),
            ...fieldBundles,
          ],
        );
        if (fieldBundle != null) {
          fieldBundles.add(fieldBundle);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return fieldBundles;
  }

  DocFieldDependsOnController? getDependsOnController({
    required DocField item,
    required List<DocFieldBundle> itemBundles,
  }) {
    DocFieldDependsOnController? controller;
    if (item.dependsOnEvalList.isNotEmpty) {
      List<DocFieldDependsOnBundle> list = [];
      for (final dependsOnEval in item.dependsOnEvalList) {
        final controller = itemBundles
            .firstWhereOrNull((itemBundle) =>
                itemBundle.field.fieldName == dependsOnEval.fieldName)
            ?.controller;
        if (controller == null) {
          continue;
        }
        list.add(DocFieldDependsOnBundle(
          controller: controller,
          operator: dependsOnEval.operator,
          expectedAnswer: dependsOnEval.expectedAnswer,
        ));
      }
      if (list.isNotEmpty) {
        controller = DocFieldDependsOnController(
          dependsOnBundleList: list,
        );
      }
    }

    return controller;
  }

  DocFieldBundle? buildFormFieldBundle({
    required DocField field,
    DocFieldDependsOnController? enableWhenController,
    Future<Attachment?> Function()? onAttachmentLoaded,
    String? groupId,
    List<DocFieldBundle>? alreadyBuiltItemBundles,
  }) {
    DocFieldView? fieldView;
    List<DocFieldBundle>? children;
    final fieldType = field.type;

    final groupIdForChildren =
        '${groupId != null ? "$groupId/" : ""}${field.fieldName}';

    children = buildFormFieldBundles(
      fields: field.children,
      onAttachmentLoaded: onAttachmentLoaded,
      groupId: groupIdForChildren,
      alreadyBuiltFieldBundles: alreadyBuiltItemBundles,
    );

    fieldView = onBuildFieldView?.call(
      field,
      enableWhenController,
      onAttachmentLoaded,
    );

    if (fieldView == null) {
      switch (fieldType ?? FieldType.unknown) {
        case FieldType.data:
          fieldView = DocFieldDataView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.text:
          fieldView = DocFieldTextView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.smallText:
          fieldView = DocFieldSmallTextView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.longText:
          fieldView = DocFieldLongTextView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.textEditor:
          fieldView = DocFieldTextEditorView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.markdownEditor:
          fieldView = DocFieldMarkdownEditorView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.int:
          fieldView = DocFieldIntView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.float:
          fieldView = DocFieldFloatView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.percent:
          fieldView = DocFieldPercentView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.currency:
          fieldView = DocFieldCurrencyView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.check:
          fieldView = DocFieldCheckView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.select:
          fieldView = DocFieldSelectView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.autocomplete:
          fieldView = DocFieldAutocompleteView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.phone:
          fieldView = DocFieldPhoneView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.password:
          fieldView = DocFieldPasswordView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.geolocation:
          fieldView = DocFieldGeolocationView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.date:
        case FieldType.time:
        case FieldType.dateTime:
          fieldView = DocFieldDateTimeView(
            field: field,
            enableWhenController: enableWhenController,
            type: DateTimeType.fromFieldType(fieldType),
          );
          break;
        case FieldType.attach:
        case FieldType.attachImage:
          fieldView = DocFieldAttachmentView(
            field: field,
            onAttachmentLoaded: onAttachmentLoaded,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.heading:
          fieldView = DocFieldHeadingView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        case FieldType.tabBreak:
          fieldView = DocFieldTabView(
            field: field,
            enableWhenController: enableWhenController,
            children: children.map((itemBundle) => itemBundle.view).toList(),
          );
          break;
        case FieldType.columnBreak:
          fieldView = DocFieldColumnView(
            field: field,
            enableWhenController: enableWhenController,
            children: children.map((itemBundle) => itemBundle.view).toList(),
          );
          break;
        case FieldType.sectionBreak:
          List<DocFieldView> finalChildrenViews = [];
          List<DocFieldView> childrenViews =
              children.map((itemBundle) => itemBundle.view).toList();
          // This logic is to group consecutive check views so they can be displayed as a list with some padding.
          for (int i = 0; i < childrenViews.length; i++) {
            DocFieldView fieldView = childrenViews[i];
            if (fieldView is DocFieldCheckView) {
              List<DocFieldView> checkListView = [];
              checkListView.add(fieldView);
              while (++i < childrenViews.length) {
                if ((fieldView = childrenViews[i]) is DocFieldCheckView) {
                  checkListView.add(fieldView);
                } else {
                  finalChildrenViews.add(DocFieldCheckListView(
                    field: DocField.dummy(),
                    children: checkListView,
                  ));
                  i--;
                  break;
                }
              }
            } else {
              finalChildrenViews.add(fieldView);
            }
          }
          fieldView = DocFieldSectionView(
            field: field,
            enableWhenController: enableWhenController,
            children: finalChildrenViews,
          );
          break;
        case FieldType.rating:
          fieldView = DocFieldRatingView(
            field: field,
            enableWhenController: enableWhenController,
          );
          break;
        //TODO: pending implementation
        case FieldType.link:
        case FieldType.dynamicLink:
        case FieldType.table:
        case FieldType.barcode:
        case FieldType.button:
        case FieldType.code:
        case FieldType.color:
        case FieldType.html:
        case FieldType.image:
        case FieldType.readOnly:
        case FieldType.signature:
        case FieldType.tableMultiSelect:
        case FieldType.duration:
        case FieldType.htmlEditor:
        case FieldType.icon:
        case FieldType.json:
        case FieldType.unknown:
          break;
        // case FieldType.quantity:
        //   itemView = DocFieldQuantityView(
        //     item: item,
        //     enableWhenController: enableWhenController,
        //   );
        //   break;
        // case FieldType.boolean:
        //   fieldView = DocFieldBooleanView(
        //     field: field,
        //     enableWhenController: enableWhenController,
        //   );
        //   break;
        // case FieldType.checkOpen:
        //   fieldView = DocFieldCheckOpenView(
        //     field: field,
        //     enableWhenController: enableWhenController,
        //   );
        //   break;
        // case FieldType.radioOpen:
        //   fieldView = DocFieldRadioOpenView(
        //     field: field,
        //     enableWhenController: enableWhenController,
        //   );
        //   break;
        // case FieldType.selectOpen:
        //   fieldView = DocFieldSelectOpenView(
        //     field: field,
        //     enableWhenController: enableWhenController,
        //   );
        //   break;
        // case FieldType.url:
        //   fieldView = DocFieldUrlView(
        //     field: field,
        //     enableWhenController: enableWhenController,
        //   );
        //   break;
      }
    }

    return fieldView != null
        ? DocFieldBundle(
            field: field,
            view: fieldView,
            children: children,
            controller: fieldView.controller,
            groupId: groupId,
          )
        : null;
  }

  Map<String, dynamic> generateResponse(
      {required DocForm form, required List<DocFieldBundle> itemBundles}) {
    List<DocFieldAnswer> fieldAnswers =
        generateFieldAnswers(fieldBundles: itemBundles);

    Map<String, dynamic> response = form.toAnswerMap();

    for (final fieldAnswer in fieldAnswers) {
      response.addAll(fieldAnswer.toAnswerMap());
    }

    return response;
  }

  List<DocFieldAnswer> generateFieldAnswers(
      {required List<DocFieldBundle> fieldBundles}) {
    List<DocFieldAnswer> fieldAnswers = [];
    for (final fieldBundle in fieldBundles) {
      final fieldAnswer = generateFieldAnswer(fieldBundle);
      if (fieldAnswer != null) {
        fieldAnswers.add(fieldAnswer);
      }
      fieldAnswers.addAll(
          generateFieldAnswers(fieldBundles: fieldBundle.children ?? []));
    }

    return fieldAnswers;
  }

  DocFieldAnswer? generateFieldAnswer(DocFieldBundle fieldBundle) {
    final fieldType = fieldBundle.field.type;

    dynamic fieldValue = switch (fieldType ?? FieldType.unknown) {
      // Excluding these types as they are not part of the response
      FieldType.tabBreak ||
      FieldType.columnBreak ||
      FieldType.sectionBreak =>
        null,
      FieldType.data ||
      FieldType.text ||
      FieldType.smallText ||
      FieldType.longText ||
      FieldType.textEditor ||
      FieldType.markdownEditor ||
      FieldType.select ||
      FieldType.geolocation ||
      FieldType.autocomplete ||
      FieldType.phone ||
      FieldType.attach ||
      FieldType.attachImage ||
      FieldType.password =>
        fieldBundle.controller.rawValue?.toString(),
      FieldType.check => fieldBundle.controller.rawValue?.toString().asInt,
      FieldType.date =>
        (fieldBundle.controller.rawValue as DateTime?)?.toJsonDate(),
      FieldType.time =>
        (fieldBundle.controller.rawValue as DateTime?)?.toJsonTime(),
      FieldType.dateTime =>
        (fieldBundle.controller.rawValue as DateTime?)?.toJsonDateTime(),
      FieldType.int => fieldBundle.controller.rawValue?.toString().asInt,
      FieldType.float ||
      FieldType.percent ||
      FieldType.currency ||
      FieldType.rating =>
        fieldBundle.controller.rawValue?.toString().asDouble,
      FieldType.heading => null,
      //TODO: pending implementation
      FieldType.link => null,
      FieldType.dynamicLink => null,
      FieldType.table => null,
      FieldType.barcode => null,
      FieldType.button => null,
      FieldType.code => null,
      FieldType.color => null,
      FieldType.html => null,
      FieldType.image => null,
      FieldType.readOnly => null,
      FieldType.signature => null,
      FieldType.tableMultiSelect => null,
      FieldType.duration => null,
      FieldType.htmlEditor => null,
      FieldType.icon => null,
      FieldType.json => null,
      FieldType.unknown => null,
    };

    DocFieldAnswer fieldAnswer =
        onGenerateFieldAnswer?.call(fieldBundle, fieldValue) ??
            DocFieldAnswer(
              type: fieldType,
              name: fieldBundle.field.fieldName,
              value: fieldValue,
            );

    return fieldAnswer;
  }
}
