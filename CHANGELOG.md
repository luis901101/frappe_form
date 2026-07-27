The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Types of changes
- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` in case of vulnerabilities.

## 0.10.0
### Added
- Added support for the field `placeholder` property, rendered as the input hint text _(on `Attach` and `Attach Image` fields, when the placeholder is an image url it is rendered as a preview image while no file is attached)_.
- Added support for `===`, `!==`, `%`, the unary `!`, `-` and `+` operators and the `true`, `false` and `null` literals on **Mandatory Depends On (JS)**, **Read Only Depends On (JS)** and **Display Depends On (JS)** expressions in fields.
- Added support for the plain non `eval:` form of the `depends_on` property _(like `depends_on: "my_check"`)_.
- Added a standalone JS expression analyzer _(`JsExpression`)_ that can be reused outside the depends-on properties.

### Changed
- **Breaking:** Depends-on expressions are now parsed into a syntax tree instead of splitting the text on operator symbols. `DocFieldDependsOnBundle` no longer exposes the `and`, `or`, `sum`, `subtract`, `multiply` and `divide` children, its generative constructor, `withCondition` nor `withArithmetic`.
- **Breaking:** The JS expression logic moved to `src/js_expression` with its own naming, so `DocFieldDependsOnOperator` is now `JsComparisonOperator`, `DocFieldDependsOnCondition` is `JsLogicalOperator` and `DocFieldDependsOnArithmetic` is `JsArithmeticOperator`.

### Fixed
- Fixed depends-on expressions ignoring operator precedence and grouping parentheses, which also dropped referenced fields from the expression.
- Fixed depends-on expressions losing the arithmetic part when mixed with conditions, like `doc.a + doc.b >= 3 && doc.c == 1`.
- Fixed depends-on expressions breaking on operator symbols inside string literals, like `doc.some_date == "2025-01-01"`.
- Fixed depends-on expressions only supporting the `doc.field <operator> literal` shape, so `5 > doc.qty` and `doc.qty > doc.min_qty` were misinterpreted.
- Fixed untouched fields not being read as their Frappe default, so `doc.some_check == 0` did not hold for an untouched checkbox.
- Fixed bare field expressions like `eval:doc.some_field` being always satisfied regardless of the field value.
- Fixed relational operators returning `false` instead of comparing as strings when the operands are not numeric.
- Fixed a field referenced more than once registering its change listener more than once.
- Fixed the listeners of a replaced depends-on expression not being detached.

### Removed
- **Breaking:** Removed the unused `DocFieldDependsOnBehavior` enum.

## 0.9.2
### Fixed
- `TextField` button icon disabled state fixed. 

## 0.9.1
### Changed
- Improved phone number parsing when filling phone input field to ensure proper US number handling.

## 0.9.0
### Added
- Added support for basic arithmetic operators _(like +,-,*,/)_ on **Mandatory Depends On (JS)**, **Read Only Depends On (JS)** and **Display Depends On (JS)** expressions in fields.

### Removed
- Removed bold style in checkbox labels.

## 0.8.0
### Added
- Implemented link tap behavior for `HTML` fields.
- Added visual indication for required fields by displaying a red asterisk (*) in field labels.

## 0.7.0
### Added
- Added support for `HTML` field type.

### Changed
- Improved `DocFieldSectionView` to properly render long Labels with round borders.
- Improved `DocFieldPhoneView` to properly load phone from default value.

## 0.6.1
### Fixed
- Fixed minor UI issue with `RadioGroup`
- Fixed issue with JS expressions parser.

## 0.6.0
### Added
- Added support for a field custom property `render_rules` to allow custom rendering of fields based on definitions.

## 0.5.0
### Added
- Added support for **Mandatory Depends On (JS)** expressions in fields _(`mandatory_depends_on` property)_.
- Added support for **Read Only Depends On (JS)** expressions in fields _(`read_only_depends_on` property)_.

### Changed
- Improved support for **Display Depends On (JS)** expressions in fields _(`depends_on` property)_.

### Fixed
- Fixed issue with content scrolling to ensure submit button to properly appear show up.

## 0.4.1
### Fixed
- Fixed `maxLength` validation to 140 chars max for `Data` field _(according to official docs)_ when no `length` is specified.

## 0.4.0
### Added
- Added support for new field `Table`.

### Changed
- Updated example project.

## 0.3.0
### Changed
- Improved scrollToField function.
- Improved DocFieldView controller initialization.

## 0.2.1
### Changed
- Improved answer generation to ignore null values.

### Fixed
- Fixed issue with DocFieldPhoneView parsing initial phone number with hyphens.
- Fixed issue with DocFieldGeolocationView initial value that was taking coordinates in the wrong order.
- Fixed issue with scroll controller when using multiple tabs.

## 0.2.0
### Added
- Added "Next" and "Back" buttons to the `DocForm` for easier navigation between tabs.
- Added support for html formatting on descriptions and Heading.

### Changed
- Changed the description location on Sections and Columns to be below the title instead of below the content.

### Fixed
- Fixed an issue with the label on Checkbox fields.

## 0.1.2
### Changed
- `html_editor_enhanced` dependency updated to latest.

## 0.1.1
### Fixed
- Fixed an issue with the `DocFieldRatingView` that was not setting the initial rating correctly. 

## 0.1.0
### Added
- Added support for `actions` widgets on AppBar.
- Fields sorted according to the `field_order` property in the `DocForm`.

### Changed
- `DocFieldAutocompleteView` updated to show options on focus.

## 0.0.1
### Added
- First release