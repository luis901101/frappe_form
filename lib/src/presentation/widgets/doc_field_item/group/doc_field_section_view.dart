import 'package:frappe_form/frappe_form.dart';
import 'package:material_ui/material_ui.dart';

/// Created by luis901101 on 04/21/25.
class DocFieldSectionView extends DocFieldView {
  DocFieldSectionView({
    super.key,
    required super.field,
    super.children,
    super.dependsOnController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldSectionViewState();
}

class DocFieldSectionViewState<SF extends DocFieldSectionView>
    extends DocFieldViewState<SF> {
  double? groupTitleHeight;
  Map<int, double?> itemWidthInfo = {};
  int maxItemRowCount = 1;
  int maxRows = 1;
  final double itemSpacing = 8.0;

  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget? buildDescriptionView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    final color = theme.colorScheme.surfaceContainer;
    final borderColor = theme.colorScheme.onSurface;
    double borderRadius = 0;
    if (theme.inputDecorationTheme.border is OutlineInputBorder) {
      borderRadius = (theme.inputDecorationTheme.border as OutlineInputBorder)
          .borderRadius
          .topLeft
          .x;
    }
    // TODO: support for different ways of presenting the group UI, like using card or container with custom border radius, etc.
    return LayoutBuilder(
      builder: (context, constraints) {
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
        maxRows = (children.length / maxItemRowCount).ceil();
        final Widget? descriptionView = field.description.isEmpty
            ? null
            : SizedBox(
                width: double.infinity,
                child: CustomHtml(
                  data: field.description!,
                  style: theme.textTheme.titleMedium?.asHtmlStyle,
                ),
              );
        final Widget? childrenView = children.isEmpty
            ? null
            // Instead of Column, we use Wrap to allow for a more flexible layout
            : Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: itemSpacing,
                runSpacing: itemSpacing,
                children: List.generate(children.length, (index) {
                  return SizedBox(
                    width: getItemWidth(screenWidth, index, children.length),
                    child: children[index],
                  );
                }),
              );
        return Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: borderColor),
                borderRadius: BorderRadius.circular(borderRadius),
                color: color,
              ),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: (groupTitleHeight ?? 0) / 2 + 16,
              ),
              margin: EdgeInsets.only(top: (groupTitleHeight ?? 0) / 2),
              child: descriptionView == null && childrenView == null
                  ? null
                  // List tiles paint their ink and hover colors on the nearest
                  // Material, which must sit above this container's fill.
                  : Material(
                      type: MaterialType.transparency,
                      textStyle: DefaultTextStyle.of(context).style,
                      child: descriptionView != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                descriptionView,
                                if (childrenView != null)
                                  Padding(
                                    padding: EdgeInsets.only(top: itemSpacing),
                                    child: childrenView,
                                  ),
                              ],
                            )
                          : childrenView,
                    ),
            ),
            if (field.title.isNotEmpty || isRequired)
              Positioned(
                left: 16,
                right: 16,
                top: 0,
                child: SizeRenderer(
                  onSizeRendered: onGroupTitleSizeRendered,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: borderColor),
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: color,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8 + (borderRadius / 4),
                        vertical: 8 + (borderRadius / 16),
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: theme.textTheme.titleMedium,
                          children: [
                            if (field.title.isNotEmpty)
                              TextSpan(text: field.title),
                            if (isRequired)
                              TextSpan(
                                text: '${field.title.isNotEmpty ? ' ' : ''}*',
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
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
