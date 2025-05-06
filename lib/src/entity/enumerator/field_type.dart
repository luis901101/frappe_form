import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// The following are the types of fields you can define while creating new ones, or while amending standard ones.
/// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#field-types
enum FieldType {
  /// Link field is connected to another master from where it fetches data. For example, in the Quotation master, the Customer is a Link field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#link
  @JsonValue('Link')
  link('Link'),

  /// Dynamic Link field is one which can search and hold value of any document/doctype.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#dynamic-link
  @JsonValue('Dynamic Link')
  dynamicLink('Dynamic Link'),

  /// This will enable you to have a checkbox here.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#check
  @JsonValue('Check')
  check('Check'),

  /// Select will be a drop-down field. You can add multiple results in the Option field, separated by row.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#select
  @JsonValue('Select')
  select('Select'),

  /// A table will be a kind of Link field which renders another DocType within the current form. For example, the Item Table in the Sales Order is a Table field, which is linked to Sales Order Item DocType.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#table
  @JsonValue('Table')
  table('Table'),

  /// Attach field allows you to browse a field from the File Manager and attach the same herein.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#attach
  @JsonValue('Attach')
  attach('Attach'),

  /// Attach Image is a field wherein you will be allowed to attach Images of the format jpeg, png, etc. This becomes the Image representing that particular DocType. For e.g., you would want the image of an Item in its DocType, you can choose your field to be an Attach Image Field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#attach-image
  @JsonValue('Attach Image')
  attachImage('Attach Image'),

  /// Text Editor is a text field. It has text-formatting options. In ERPNext, this field is generally used for defining Terms and Conditions.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#text-editor
  @JsonValue('Text Editor')
  textEditor('Text Editor'),

  /// HTML editor like coding html editor
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#html-editor
  @JsonValue('HTML Editor')
  htmlEditor('HTML Editor'),

  /// This field will enable you to enter the Date in this field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#date
  @JsonValue('Date')
  date('Date'),

  /// This field will give you a date and time picker. The current date and time (as provided by your computer) are set by default.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#date-and-time
  @JsonValue('Datetime')
  dateTime('Datetime'),

  /// In this field, you can specify the field as Barcode which will allow you to enter a Barcode number. Oce you do that, the Barcode would automatically get generated against the number.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#barcode
  @JsonValue('Barcode')
  barcode('Barcode'),

  /// This kind of field will be an action button, like Save, Submit, etc.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#button
  @JsonValue('Button')
  button('Button'),

  /// If the Field Type is selected as code, you will be able to enter a Code to the field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#code
  @JsonValue('Code')
  code('Code'),

  /// You will have the option of specifying the color for this Form.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#color
  @JsonValue('Color')
  color('Color'),

  /// Since ERPNext has multiple column layouts, using Column Breaks, you can divide a set of fields into a maximum of two columns.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#column-break
  @JsonValue('Column Break')
  columnBreak('Column Break'),

  /// Currency field holds numeric value, like Item Price, Amount, etc. Currency field can have value up to six decimal places. Also, you can have a currency symbol being shown for the currency field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#currency
  @JsonValue('Currency')
  currency('Currency'),

  /// The data field will be a simple text field. It allows you to enter a value of up to 140 characters, making this the most generic field type. To enable validations for Email, Name, or Phone Number inputs, set options to "Email", "Name", "Phone" in Settings &gt; DocType.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#data
  @JsonValue('Data')
  data('Data'),

  /// Float field carries numeric value, up to nine decimal places.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#float
  @JsonValue('Float')
  float('Float'),

  /// Use Geolocation field to store GeoJSON.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#geolocation
  @JsonValue('Geolocation')
  geolocation('Geolocation'),

  /// You can select the field to be an HTML field when you want the data to be entered in HTML format.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#html
  @JsonValue('HTML')
  html('HTML'),

  /// Image field will render an image file selected in another attach field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#image
  @JsonValue('Image')
  image('Image'),

  /// The integer field holds numeric value, without decimal place.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#int-integer
  @JsonValue('Int')
  int('Int'),

  /// Small Text field carries text content and has more character limit than the Data field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#small-text
  @JsonValue('Small Text')
  smallText('Small Text'),

  /// You can define your field to a Long Text Field when you would want to enter data with an unlimited character limit.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#long-text
  @JsonValue('Long Text')
  longText('Long Text'),

  /// This field type would allow you to add text in the field. The character limit in Small text, Long text and Text fields shall be determined based on the Relational Database Management System.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#text
  @JsonValue('Text')
  text('Text'),

  /// Phone
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#phone
  @JsonValue('Phone')
  phone('Phone'),

  /// This field will allow you to add the text in Markup language.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#markdown-editor
  @JsonValue('Markdown Editor')
  markdownEditor('Markdown Editor'),

  /// The password field will have decoded value in it.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#password
  @JsonValue('Password')
  password('Password'),

  /// You can define the field as a Percentage field which in the background will be calculated as a percentage.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#percent
  @JsonValue('Percent')
  percent('Percent'),

  /// You can define the field as a Rate field which in the background will be calculated as Rating.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#rating
  @JsonValue('Rating')
  rating('Rating'),

  /// Read Only field will carry data fetched from another form which will be non-editable. You should set Read Only as field type if its source for value is predetermined.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#read-only
  @JsonValue('Read Only')
  readOnly('Read Only'),

  /// Section Break is used to divide the form into multiple sections.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#section-break
  @JsonValue('Section Break')
  sectionBreak('Section Break'),

  /// You can define the field to be a Signature field wherein you can add the Digital Signature in this field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#signature
  @JsonValue('Signature')
  signature('Signature'),

  /// This is a combination of 'Link' type and 'Table' type fields. Instead of a child table with 'Add Row' button, in one field multiple values can be selected.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#table-multiselect
  @JsonValue('Table MultiSelect')
  tableMultiSelect('Table MultiSelect'),

  /// This is a Time field where you can define the Time in the field.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#time
  @JsonValue('Time')
  time('Time'),

  /// You can use the Duration field if you want to define a timespan.
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#duration
  @JsonValue('Duration')
  duration('Duration'),

  /// To divide layouts into tabs
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#tab-break
  @JsonValue('Tab Break')
  tabBreak('Tab Break'),

  /// To divide layouts into tabs
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#autocomplete
  @JsonValue('Autocomplete')
  autocomplete('Autocomplete'),

  /// A heading text
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#heading
  @JsonValue('Heading')
  heading('Heading'),

  /// Icon
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#icon
  @JsonValue('Icon')
  icon('Icon'),

  /// JSON
  /// Docs: https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#json
  @JsonValue('JSON')
  json('JSON'),

  /// Only for internal use
  @JsonValue('unknown')
  unknown('unknown'),
  ;

  final String name;
  const FieldType(this.name);

  bool get isGroup => switch (this) {
        FieldType.tabBreak ||
        FieldType.sectionBreak ||
        FieldType.columnBreak =>
          true,
        _ => false,
      };

  bool get isAnswerable => switch (this) {
        FieldType.tabBreak ||
        FieldType.sectionBreak ||
        FieldType.columnBreak ||
        FieldType.heading =>
          false,
        _ => true,
      };

  /// - No type can have the same type as child
  /// - Tab Break can have any type as child
  /// - Section Break can have any type as child except Tab Break
  /// - Column Break can have any type as child except Tab Break and Section Break
  bool canHaveAsChild(FieldType type) =>
      this != type &&
      switch (this) {
        FieldType.tabBreak => true,
        FieldType.sectionBreak => type != FieldType.tabBreak,
        FieldType.columnBreak =>
          type != FieldType.tabBreak && type != FieldType.sectionBreak,
        _ => false,
      };

  bool get isParentGroupType => this == FieldType.tabBreak;

  static FieldType? valueOf(String? name) =>
      FieldType.values.firstWhereOrNull((value) => value.name == name);
}
