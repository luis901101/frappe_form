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
    super.dependsOnController,
  }) : super(
         controller:
             controller ??
             CustomValueController<Attachment>(focusNode: FocusNode()),
       );

  @override
  State createState() => DocFieldAttachmentViewState();
}

class DocFieldAttachmentViewState<SF extends DocFieldAttachmentView>
    extends DocFieldViewState<SF> {
  bool isLoading = false;
  @override
  CustomValueController<Attachment> get controller =>
      super.controller as CustomValueController<Attachment>;
  Attachment? get value => controller.value;
  set value(Attachment? value) => controller.value = value;

  Widget buildIcon(IconData icon) =>
      Icon(icon, color: theme.disabledColor, size: 96);

  Widget onImageError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) => buildIcon(Icons.broken_image);

  @override
  Widget buildBody(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final showValue = value?.isImage == true && value?.hasSource == true;
    final isPlaceholderUrl = placeholder?.isUrl() ?? false;
    final showPlaceholder = value == null && isPlaceholderUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.center,
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              height: value == null && !showPlaceholder ? 0 : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: showValue || showPlaceholder
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          clipBehavior: Clip.hardEdge,
                          child: showValue
                              ? (!kIsWeb && value!.path.isNotEmpty
                                    ? Image.file(
                                        File(value?.path ?? ''),
                                        semanticLabel: !isPlaceholderUrl
                                            ? placeholder
                                            : null,
                                        errorBuilder: onImageError,
                                      )
                                    : Image.network(
                                        value?.url ?? value?.path ?? '',
                                        semanticLabel: !isPlaceholderUrl
                                            ? placeholder
                                            : null,
                                        errorBuilder: onImageError,
                                      ))
                              : Image.network(
                                  placeholder ?? '',
                                  errorBuilder: onImageError,
                                ),
                        )
                      : buildIcon(
                          (value?.mediaType?.endsWith('jpeg') ?? false)
                              ? Icons.image
                              : Icons.file_copy,
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
                    width: mediaQuery.size.width.percent(
                      value == null ? 80 : 40,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: isReadOnly || isLoading ? null : onBtnUpload,
                      icon: Icon(
                        value == null ? Icons.upload_rounded : Icons.refresh,
                      ),
                      label: Text(
                        value == null
                            ? DocFormLocalization
                                  .instance
                                  .localization
                                  .btnUpload
                            : DocFormLocalization
                                  .instance
                                  .localization
                                  .btnChange,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(width: value == null ? 0 : 8),
              ),
              Flexible(
                flex: value == null ? 0 : 1,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: value == null
                        ? 0
                        : mediaQuery.size.width.percent(40),
                    child: ElevatedButton.icon(
                      onPressed: isReadOnly || isLoading ? null : onBtnRemove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        iconColor: theme.colorScheme.onError,
                      ),
                      icon: const Icon(Icons.delete_forever_rounded),
                      label: Text(
                        DocFormLocalization.instance.localization.btnRemove,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
