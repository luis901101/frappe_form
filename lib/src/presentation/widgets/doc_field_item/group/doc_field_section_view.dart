import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldSectionView extends DocFieldView {
  DocFieldSectionView({
    super.key,
    required super.field,
    super.children,
    super.enableWhenController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldSectionViewState();
}

class DocFieldSectionViewState extends DocFieldViewState<DocFieldSectionView> {
  double? groupTitleHeight;
  Map<int, double?> itemWidthInfo = {};
  int maxItemRowCount = 1;
  int maxRows = 1;
  final double itemSpacing = 8.0;

  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    double borderRadius = 0;
    if (theme.inputDecorationTheme.border is OutlineInputBorder) {
      borderRadius = (theme.inputDecorationTheme.border as OutlineInputBorder)
          .borderRadius
          .topLeft
          .x;
    }
    // TODO: support for different ways of presenting the group UI, like using card or container with custom border radius, etc.
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      itemWidthInfo.clear();
      maxItemRowCount = 1;
      maxRows = 1;
      if (screenWidth > 1200) {
        maxItemRowCount = 3;
        itemWidthInfo[3] = (screenWidth / 3) - (3 + 1) * itemSpacing;
      }
      if (screenWidth > 600) {
        if (maxItemRowCount == 1) {
          maxItemRowCount = 2;
        }
        itemWidthInfo[2] = (screenWidth / 2) - (2 + 1) * itemSpacing;
      }
      maxRows = ((children?.length ?? 0) / maxItemRowCount).ceil();
      return Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(borderRadius)),
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: groupTitleHeight != null ? groupTitleHeight! : 24),
            margin: const EdgeInsets.only(top: 14),
            child: children == null
                ? null
                // Instead of Column, we use Wrap to allow for a more flexible layout
                : Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: itemSpacing,
                    runSpacing: itemSpacing,
                    children: List.generate(children?.length ?? 0, (index) {
                      return SizedBox(
                        width:
                            getItemWidth(screenWidth, index, children!.length),
                        child: children![index],
                      );
                    }),
                  ),
          ),
          if (field.title.isNotEmpty)
            Positioned(
                left: 16,
                right: 16,
                top: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: theme.colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizeRenderer(
                      onSizeRendered: onGroupTitleSizeRendered,
                      child: Text(
                        field.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                )),
        ],
      );
    });
  }

  double? getItemWidth(double screenWidth, int index, int length) {
    int rowIndex = ((index + 1) / maxItemRowCount).ceil();

    if (rowIndex == maxRows) {
      int itemsExpectedTotal = maxItemRowCount * maxRows;
      if (itemsExpectedTotal > length) {
        int lastRowItemsRemaining = length - (maxItemRowCount * (maxRows - 1));
        return itemWidthInfo[lastRowItemsRemaining];
      }
    }

    return itemWidthInfo[3] ?? itemWidthInfo[2] ?? itemWidthInfo[1];
  }

  void onGroupTitleSizeRendered(Size size, GlobalKey key) {
    if (groupTitleHeight == null) {
      setState(() => groupTitleHeight = size.height);
    }
  }
}
