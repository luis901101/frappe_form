import 'package:material_ui/material_ui.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

extension HtmlStyle on TextStyle {
  Style get asHtmlStyle => Style(
    padding: HtmlPaddings.zero,
    margin: Margins.zero,
    fontSize: fontSize == null ? null : FontSize(fontSize!),
    fontWeight: fontWeight,
    color: color,
    textAlign: TextAlign.start,
    fontFamily: fontFamily,
  );
}

class CustomHtml extends Html {
  static OnTap defaultOnLinkTap = (url, attributes, element) {
    final Uri? uri = Uri.tryParse(url ?? '');
    if (uri != null) {
      launchUrl(uri);
    }
  };

  CustomHtml({
    super.key,
    super.anchorKey,
    super.data,
    OnTap? onLinkTap,
    super.onAnchorTap,
    List<HtmlExtension> extensions = const [],
    super.onCssParseError,
    super.shrinkWrap = true,
    super.onlyRenderTheseTags,
    super.doNotRenderTheseTags,
    Map<String, Style>? styleMap,
    Style? style,
  }) : super(
         onLinkTap: onLinkTap ?? defaultOnLinkTap,
         // Added last: flutter_html tries the given extensions in order, so
         // one that handles `<details>` itself still wins.
         extensions: [...extensions, const _DetailsExtension()],
         style: styleMap ?? (style == null ? {} : {'body': style, 'p': style}),
       );
}

/// flutter_html's `<details>` built-in, rebuilt on the `material_ui`
/// [ExpansionTile]: the built-in one is SDK Material and would need an SDK
/// `Material` ancestor and theme.
class _DetailsExtension extends HtmlExtension {
  const _DetailsExtension();

  @override
  Set<String> get supportedTags => {'details'};

  @override
  StyledElement prepare(
    ExtensionContext context,
    List<StyledElement> children,
  ) {
    return StyledElement(
      name: context.elementName,
      children: children,
      style: Style(),
      node: context.node,
    );
  }

  @override
  InlineSpan build(ExtensionContext context) {
    final childList = context.builtChildrenMap!;
    final children = childList.values;
    final hasSummary =
        childList.keys.isNotEmpty && childList.keys.first.name == 'summary';

    InlineSpan? firstChild = children.isNotEmpty ? children.first : null;
    return WidgetSpan(
      child: ExpansionTile(
        key: AnchorKey.of(context.parser.key, context.styledElement!),
        expandedAlignment: Alignment.centerLeft,
        title: hasSummary
            ? CssBoxWidget.withInlineSpanChildren(
                children: firstChild == null ? [] : [firstChild],
                style: context.styledElement!.style,
              )
            : const Text('Details'),
        children: [
          CssBoxWidget.withInlineSpanChildren(
            children: hasSummary
                ? children.skip(1).toList()
                : children.toList(),
            style: context.styledElement!.style,
          ),
        ],
      ),
    );
  }
}
