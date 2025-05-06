import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 05/02/25.
class DocFieldAttachmentView extends DocFieldView {
  final Future<Attachment?> Function()? onAttachmentLoaded;
  DocFieldAttachmentView({
    super.key,
    CustomValueController<Attachment>? controller,
    required super.field,
    required this.onAttachmentLoaded,
    super.enableWhenController,
  }) : super(
            controller: controller ??
                CustomValueController<Attachment>(
                  focusNode: FocusNode(),
                ));

  @override
  State createState() => DocFieldAttachmentViewState();
}

class DocFieldAttachmentViewState
    extends DocFieldViewState<DocFieldAttachmentView> {
  bool isLoading = false;
  @override
  CustomValueController<Attachment> get controller =>
      super.controller as CustomValueController<Attachment>;
  Attachment? get value => controller.value;
  set value(Attachment? value) => controller.value = value;

  @override
  Widget buildBody(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 4.0,
            ),
            child: Text(
              field.title,
              style: theme.textTheme.titleSmall,
            ),
          ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              height: value == null ? 0 : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child:
                      ((value?.isImage ?? false) && (value?.hasSource ?? false))
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              clipBehavior: Clip.hardEdge,
                              child: !kIsWeb && value!.path.isNotEmpty
                                  ? Image.file(
                                      File(value?.path ?? ''),
                                    )
                                  : Image.network(
                                      value?.url ?? value?.path ?? '',
                                    ),
                            )
                          : Icon(
                              (value?.mediaType?.endsWith('jpeg') ?? false)
                                  ? Icons.image
                                  : Icons.file_copy,
                              color: theme.disabledColor,
                              size: 96,
                            ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 48.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width:
                        mediaQuery.size.width.percent(value == null ? 80 : 40),
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : onBtnUpload,
                      icon: Icon(
                          value == null ? Icons.upload_rounded : Icons.refresh),
                      label: Text(value == null
                          ? DocFormLocalization.instance.localization.btnUpload
                          : DocFormLocalization
                              .instance.localization.btnChange),
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: value == null ? 0 : 8,
                  )),
              Flexible(
                flex: value == null ? 0 : 1,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width:
                        value == null ? 0 : mediaQuery.size.width.percent(40),
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : onBtnRemove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        iconColor: theme.colorScheme.onError,
                      ),
                      icon: const Icon(Icons.delete_forever_rounded),
                      label: Text(
                          DocFormLocalization.instance.localization.btnRemove),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (handleControllerErrorManually && controller.hasError)
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 4.0,
            ),
            child: Text(
              '${controller.error}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> onBtnUpload() async {
    setState(() {
      isLoading = true;
    });
    final temp = await widget.onAttachmentLoaded?.call();
    setState(() {
      if (temp != null) {
        value = temp;
      }
      isLoading = false;
    });
  }

  Future<void> onBtnRemove() async {
    value = null;
    setState(() {});
  }
}
