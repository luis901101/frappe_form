
# Frappe Form 

A Flutter package for rendering Frappe Forms.

This package takes care of building the UI of a **Frappe Form**, handle behavior and validations and finally generates the **Response** from the user answers.

## Supported DocType form fields
So far this package supports the following [Field Types](https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#field-types)
| Field Type | Supported |  
| ------ | ------ |  
| Tab Break | :white_check_mark: |
| Column Break | :white_check_mark: |
| Section Break | :white_check_mark: |
| Data | :white_check_mark: |
| Text | :white_check_mark: |
| Small Text | :white_check_mark: |
| Long Text | :white_check_mark: |
| Text Editor | :white_check_mark: |
| Markdown Editor | :white_check_mark: |
| Select | :white_check_mark: |
| Geolocation | :white_check_mark: |
| Autocomplete | :white_check_mark: |
| Phone | :white_check_mark: |
| Attach | :white_check_mark: |
| Attach Image | :white_check_mark: |
| Password | :white_check_mark: |
| Check | :white_check_mark: |
| Date | :white_check_mark: |
| Time | :white_check_mark: |
| Datetime | :white_check_mark: |
| Int | :white_check_mark: |
| Float | :white_check_mark: |
| Percent | :white_check_mark: |
| Currency | :white_check_mark: |
| Rating | :white_check_mark: |
| Heading | :white_check_mark: |
| Link | :ballot_box_with_check: |  
| Dynamic Link | :ballot_box_with_check: |  
| Table | :ballot_box_with_check: |  
| Barcode | :ballot_box_with_check: |  
| Button | :ballot_box_with_check: |  
| Code | :ballot_box_with_check: |  
| Color | :ballot_box_with_check: |  
| HTML | :ballot_box_with_check: |  
| Image | :ballot_box_with_check: |  
| Read Only | :ballot_box_with_check: |  
| Signature | :ballot_box_with_check: |  
| Table MultiSelect | :ballot_box_with_check: |  
| Duration | :ballot_box_with_check: |  
| HTML Editor | :ballot_box_with_check: |  
| Icon | :ballot_box_with_check: |  
| JSON | :ballot_box_with_check: |  

## Supported extra features
1. Depends on evaluations
2. Required fields
3. Read only fields
4. Description
5. Default value


## How to use
Just add a `DocFormView` widget to your widget tree and you will have your Frappe Form UI.

```dart
DocFormView(
    form: form, // A Frappe Form instance
    onAttachmentLoaded: onAttachmentLoaded, // A callback to handle attachment loading (explained below) 
    locale: locale, // The specific locale for the Button and validation texts
    localizations: localizations, // To add support for extra localization 
    isLoading: loading, // Whether is some ongoing operation before loading the UI 
    onSubmit: onSubmit, // Callback to get the Form Response
    controller: controller, // The DocFormController to use for item view and response generation.
)
```

## DocFormView
1. **DocForm form:** `DocFormView` requires an object of type **DocForm** this is the definition of the Frappe Form and will be used to build the Form UI and generate the Questions and Answers.
2. **Locale? locale**: Optionally you can specify the language like "es" or "en" or "fr", etc. you want as a Locale object to use for validation messages and Submit button, by default the system language will be used.
3. **List<DocFormBaseLocalization>? localizations**: this is a list that allows you to add extra language translations to the Form UI, currently the package supports only English and Spanish, so you can add other Languages, you just need to create a class for each new Language you want to support and extend **DocFormBaseLocalization**.
4. **DocFormBaseLocalization? defaultLocalization**: Indicates what should be the fallback localization if the specified language or the system language is not supported, by default English is the fallback.
5. **bool isLoading**: use this to indicate there is an ongoing operation, for instance if you need to make an API request to load your **DocForm** you can set `isLoading = true` so the `DocFormView` will show a Shimmer loading effect view.
6. **Future<Attachment?> Function()? onAttachmentLoaded**: To make this package simpler and compatible with all Flutter supported platforms, the feature to load an attachment is delegated to the App, so you have to handle this logic by implementing this function and returning an instance of `Attachment`.
7. **ValueChanged<Map<String, dynamic>> onSubmit**: This is the callback that will be triggered once the user taps on the Submit button, and you will get a `Map<String, dynamic>` instance with all the answers covered.
8. **DocFormController? controller**: This is the controller to be used for questions and response generation within the `DocFormView`, the purpose of this controller here is to allow you to use an instance of an extension of `DocFormController` so you can override the behavior and widgets.

## Some extra notes
1. This widget will use the app Theme to build, so if you want to change colors, InputDecorations, etc, you just have to change it in your app Theme. Also all the package widgets are public and exposed so you could override it if necessary.
2. The `DocFormView` implementation takes care of validations depending on each `DocField` definition.
3. Check the example project which shows all the features in action.

## Demo
### [Try the demo app here](https://luis901101.github.io/frappe_form)