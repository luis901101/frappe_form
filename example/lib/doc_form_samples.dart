class DocFormSamples {
  static const fieldTest = r'''
{
    "actions": [],
    "allow_rename": 1,
    "creation": "2025-07-04 10:00:57.319696",
    "custom": 1,
    "description": "FieldTest description sample",
    "doctype": "DocType",
    "engine": "InnoDB",
    "field_order": [
      "intro_tab",
      "section_break_ydxz",
      "html_intro",
      "tab_texts",
      "section_multiline_texts",
      "column_break_ofje",
      "heading",
      "data",
      "int",
      "float",
      "currency",
      "percent",
      "password",
      "phone",
      "full_name",
      "first_name",
      "last_name",
      "email",
      "column_break_vswc",
      "text",
      "small_text",
      "long_text",
      "markdown",
      "text_editor",
      "tab_dates",
      "dates_section",
      "date",
      "time",
      "date_time",
      "select_tab",
      "section_break_cwwe",
      "autocomplete",
      "select",
      "check_liked_option_3",
      "select_how_much",
      "tab_4_tab",
      "section_break_viat",
      "attach",
      "attach_image",
      "miscellaneous",
      "section_break_omsq",
      "rating",
      "geolocation",
      "section_with_depends",
      "check_1",
      "check_2",
      "check_3",
      "none_of_the_above_check",
      "none_of_the_above_text",
      "another_section_with_depends_section",
      "check1",
      "check2",
      "check3",
      "check4",
      "check5",
      "custom_fields_tab",
      "gallery_section",
      "photo_1",
      "photo_2",
      "photo_3",
      "video_1",
      "video_2",
      "video_3",
      "place",
      "location",
      "place_data",
      "section_break_moic",
      "video",
      "tab_table",
      "ingredients_and_quantities_section",
      "recipe_evaluation_ingredients",
      "media_uploads_section",
      "media"
    ],
    "fields": [
      {
        "fieldname": "intro_tab",
        "fieldtype": "Tab Break",
        "label": "Intro"
      },
      {
        "fieldname": "section_break_ydxz",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "html_intro",
        "fieldtype": "HTML",
        "options": "<section>\n  <h2 style=\"color:#d35400;\">Freshly Hand-Tossed Pizza</h2>\n\n  <p>\n    <strong>Freshly hand-tossed dough</strong>, <em>slow-risen</em> for the perfect \n    <span style=\"color:#8e44ad;\">crunch</span> and <span style=\"color:#16a085;\">chew</span>, \n    topped with <span style=\"color:#c0392b;\"><strong>rich tomato sauce</strong></span> \n    and the <em>finest mozzarella</em>.\n  </p>\n\n  <p>\n    Each pizza is baked to <strong>golden perfection</strong> in our \n    <span style=\"color:#7f8c8d;\"><em>stone oven</em></span>, bringing out \n    <span style=\"color:#2c3e50;\">bold flavors</span> in every bite.\n  </p>\n\n  <br>\n  <ol>\n    <li><a target=\"_blank\" href=\"https://www.google.com\">\ud83d\udc40 Tap here to see</a></li>\n    <li><a target=\"_blank\" href=\"https://www.google.com\">\ud83c\udf10 www.google.com</a></li>\n    <li><a target=\"_blank\" href=\"mailto:smith@example.org?subject=News&amp;body=New%20plugin\">\ud83d\udce7 Send email</a></li>\n    <li><a target=\"_blank\" href=\"tel:+1-555-010-999\">\ud83d\udcde Make call</a></li>\n    <li><a target=\"_blank\" href=\"sms:+1-555-010-999\">\ud83d\udcac Send message</a></li>\n  </ol>\n\n  <h3 style=\"color:#2980b9;\">Choose Your Experience</h3>\n  <ul>\n    <li><em>Timeless classics</em></li>\n    <li><strong><span style=\"color:#27ae60;\">Chef\u2019s specialty creations</span></strong></li>\n  </ul>\n\n  <ol>\n    <li>Always made to share</li>\n    <li><strong><span style=\"color:#e74c3c;\">Always made with love</span></strong></li>\n  </ol>\n</section>\n"
      },
      {
        "fieldname": "tab_texts",
        "fieldtype": "Tab Break",
        "label": "Texts"
      },
      {
        "description": "A section with multiple type of \ntexts.",
        "fieldname": "section_multiline_texts",
        "fieldtype": "Section Break",
        "label": "This is a sample of a Section Label too long, to see how it fit in a mobile screen"
      },
      {
        "fieldname": "column_break_ofje",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "heading",
        "fieldtype": "Heading",
        "label": "Heading"
      },
      {
        "fieldname": "data",
        "fieldtype": "Data",
        "in_list_view": 1,
        "label": "Data",
        "placeholder": "Enter some name here",
        "reqd": 1
      },
      {
        "fieldname": "int",
        "fieldtype": "Int",
        "placeholder": "Enter some integer",
        "label": "Int"
      },
      {
        "fieldname": "float",
        "fieldtype": "Float",
        "label": "Float",
        "placeholder": "Enter some float",
        "precision": "3"
      },
      {
        "fieldname": "currency",
        "fieldtype": "Currency",
        "label": "Currency",
        "precision": "2"
      },
      {
        "fieldname": "percent",
        "fieldtype": "Percent",
        "label": "Percent"
      },
      {
        "fieldname": "password",
        "fieldtype": "Password",
        "label": "Password"
      },
      {
        "fieldname": "phone",
        "fieldtype": "Phone",
        "label": "Phone",
        "render_rules": "{\n  \"type\": \"FILL_WITH_PHONE\"\n}"
      },
      {
        "fieldname": "full_name",
        "fieldtype": "Data",
        "label": "Full name",
        "render_rules": "{\n  \"type\": \"FILL_WITH_FULL_NAME\"\n}"
      },
      {
        "fieldname": "first_name",
        "fieldtype": "Data",
        "label": "First name",
        "render_rules": "{\n  \"type\": \"FILL_WITH_FIRST_NAME\"\n}"
      },
      {
        "fieldname": "last_name",
        "fieldtype": "Data",
        "label": "Last name",
        "render_rules": "{\n  \"type\": \"FILL_WITH_LAST_NAME\"\n}"
      },
      {
        "fieldname": "email",
        "fieldtype": "Data",
        "label": "Email",
        "render_rules": "{\n  \"type\": \"FILL_WITH_EMAIL\"\n}"
      },
      {
        "fieldname": "column_break_vswc",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "text",
        "fieldtype": "Text",
        "label": "Text"
      },
      {
        "fieldname": "small_text",
        "fieldtype": "Small Text",
        "label": "Small text"
      },
      {
        "fieldname": "long_text",
        "fieldtype": "Long Text",
        "label": "Long text"
      },
      {
        "fieldname": "markdown",
        "fieldtype": "Markdown Editor",
        "label": "Markdown"
      },
      {
        "fieldname": "text_editor",
        "fieldtype": "Text Editor",
        "label": "Text editor"
      },
      {
        "fieldname": "tab_dates",
        "fieldtype": "Tab Break",
        "label": "Dates"
      },
      {
        "description": "A section with multiple type of dates",
        "fieldname": "dates_section",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "date",
        "fieldtype": "Date",
        "label": "Date"
      },
      {
        "fieldname": "time",
        "fieldtype": "Time",
        "label": "Time"
      },
      {
        "fieldname": "date_time",
        "fieldtype": "Datetime",
        "label": "Date time"
      },
      {
        "fieldname": "select_tab",
        "fieldtype": "Tab Break",
        "label": "Select"
      },
      {
        "description": "A section with multiple dropdowns",
        "fieldname": "section_break_cwwe",
        "fieldtype": "Section Break"
      },
      {
        "description": "Select one of the autocomplete values",
        "fieldname": "autocomplete",
        "fieldtype": "Autocomplete",
        "label": "Autocomplete",
        "placeholder": "Start typing \"Autocomplete\"",
        "options": "Autocomplete 1\nAutocomplete 2\nAutocomplete 3"
      },
      {
        "description": "Select Option 3 to test dependency eval",
        "fieldname": "select",
        "fieldtype": "Select",
        "label": "Select",
        "placeholder": "Tap to select some value",
        "options": "\nOption 1\nOption 2\nOption 3"
      },
      {
        "default": "0",
        "depends_on": "eval:doc.select=='Option 3'",
        "fieldname": "check_liked_option_3",
        "fieldtype": "Check",
        "label": "Liked option 3?"
      },
      {
        "depends_on": "eval:doc.check_liked_option_3==1 && doc.select=='Option 3'",
        "description": "This is a Select with a configuration of Render Rules to be rendered as a Radio Group",
        "fieldname": "select_how_much",
        "fieldtype": "Select",
        "label": "How much",
        "mandatory_depends_on": "eval:doc.check_liked_option_3==1 && doc.select=='Option 3'",
        "options": "Little bit\nNormal\nToo much",
        "render_rules": "{\n   \"type\": \"RADIO_GROUP\"\n}"
      },
      {
        "fieldname": "tab_4_tab",
        "fieldtype": "Tab Break",
        "label": "Attach"
      },
      {
        "description": "A section with multiple attachs",
        "fieldname": "section_break_viat",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "attach",
        "fieldtype": "Attach",
        "placeholder": "https://images.unsplash.com/photo-1784908927302-4e9c0128e113?q=80&w=1750&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Attach"
      },
      {
        "fieldname": "attach_image",
        "fieldtype": "Attach Image",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Attach image"
      },
      {
        "fieldname": "miscellaneous",
        "fieldtype": "Tab Break",
        "label": "Miscellaneous"
      },
      {
        "description": "A section with miscellaneous fields",
        "fieldname": "section_break_omsq",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "rating",
        "fieldtype": "Rating",
        "label": "Rating"
      },
      {
        "fieldname": "geolocation",
        "fieldtype": "Geolocation",
        "label": "Geolocation"
      },
      {
        "fieldname": "section_with_depends",
        "fieldtype": "Section Break",
        "label": "Section with Depends",
        "mandatory_depends_on": "eval:doc.none_of_the_above_check == 0 && doc.check_1 == 0 && doc.check_2 == 0 && doc.check_3 == 0"
      },
      {
        "default": "0",
        "fieldname": "check_1",
        "fieldtype": "Check",
        "label": "Check 1",
        "read_only_depends_on": "eval:doc.none_of_the_above_check == 1"
      },
      {
        "default": "0",
        "fieldname": "check_2",
        "fieldtype": "Check",
        "label": "Check 2",
        "read_only_depends_on": "eval:doc.none_of_the_above_check == 1"
      },
      {
        "default": "0",
        "fieldname": "check_3",
        "fieldtype": "Check",
        "label": "Check 3",
        "read_only_depends_on": "eval:doc.none_of_the_above_check == 1"
      },
      {
        "default": "0",
        "description": "Check this to test dependency eval: display, read only and mandatory",
        "fieldname": "none_of_the_above_check",
        "fieldtype": "Check",
        "label": "None of the above"
      },
      {
        "depends_on": "eval:doc.none_of_the_above_check == 1",
        "fieldname": "none_of_the_above_text",
        "fieldtype": "Small Text",
        "label": "Your own answer",
        "mandatory_depends_on": "eval:doc.none_of_the_above_check == 1"
      },
      {
        "description": "Only 3 checks can be checked",
        "fieldname": "another_section_with_depends_section",
        "fieldtype": "Section Break",
        "label": "Another section with Depends"
      },
      {
        "default": "0",
        "fieldname": "check1",
        "fieldtype": "Check",
        "label": "Check 1",
        "read_only_depends_on": "eval:doc.check2 + doc.check3 + doc.check4 + doc.check5 >= 3"
      },
      {
        "default": "0",
        "fieldname": "check2",
        "fieldtype": "Check",
        "label": "Check 2",
        "read_only_depends_on": "eval:doc.check1 + doc.check3 + doc.check4 + doc.check5 >= 3"
      },
      {
        "default": "0",
        "fieldname": "check3",
        "fieldtype": "Check",
        "label": "Check 3",
        "read_only_depends_on": "eval:doc.check1 + doc.check2 + doc.check4 + doc.check5 >= 3"
      },
      {
        "default": "0",
        "fieldname": "check4",
        "fieldtype": "Check",
        "label": "Check 4",
        "read_only_depends_on": "eval:doc.check1 + doc.check2 + doc.check3 + doc.check5 >= 3"
      },
      {
        "default": "0",
        "fieldname": "check5",
        "fieldtype": "Check",
        "label": "Check 5",
        "read_only_depends_on": "eval:doc.check1 + doc.check2 + doc.check3 + doc.check4 >= 3"
      },
      {
        "fieldname": "custom_fields_tab",
        "fieldtype": "Tab Break",
        "label": "Custom fields"
      },
      {
        "fieldname": "gallery_section",
        "fieldtype": "Section Break",
        "label": "Photos and Video Gallery",
        "render_rules": "{\n    \"type\": \"GALLERY\"\n}"
      },
      {
        "fieldname": "photo_1",
        "fieldtype": "Attach Image",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Photo 1",
        "reqd": 1
      },
      {
        "fieldname": "photo_2",
        "fieldtype": "Attach",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Photo 2"
      },
      {
        "fieldname": "photo_3",
        "fieldtype": "Attach",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Photo 3"
      },
      {
        "fieldname": "video_1",
        "fieldtype": "Attach",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Video 1",
        "render_rules": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 60000\n}"
      },
      {
        "fieldname": "video_2",
        "fieldtype": "Attach",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Video 2",
        "render_rules": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 60000\n}"
      },
      {
        "fieldname": "video_3",
        "fieldtype": "Attach",
        "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
        "label": "Video 3",
        "render_rules": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 60000\n}"
      },
      {
        "fieldname": "place",
        "fieldtype": "Section Break",
        "label": "Place",
        "render_rules": "{\n    \"type\": \"PLACE\"\n}"
      },
      {
        "fieldname": "location",
        "fieldtype": "Geolocation",
        "label": "Location"
      },
      {
        "fieldname": "place_data",
        "fieldtype": "Long Text",
        "label": "Place Data",
        "reqd": 1
      },
      {
        "fieldname": "section_break_moic",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "video",
        "fieldtype": "Attach",
        "label": "Video",
        "render_rules": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 30000\n}"
      },
      {
        "fieldname": "tab_table",
        "fieldtype": "Tab Break",
        "label": "Table"
      },
      {
        "description": "<strong>Take photo of Recipe/Formula</strong>",
        "fieldname": "ingredients_and_quantities_section",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "recipe_evaluation_ingredients",
        "fieldtype": "Table",
        "label": "Recipe Evaluation Ingredients",
        "options": "Recipe Evaluation Ingredients",
        "reqd": 1,
        "child_table": {
          "actions": [],
          "allow_rename": 1,
          "creation": "2025-06-26 13:04:50.708296",
          "doctype": "DocType",
          "editable_grid": 1,
          "engine": "InnoDB",
          "field_order": [
            "ingredient",
            "quantity",
            "photo"
          ],
          "fields": [
            {
              "fieldname": "ingredient",
              "fieldtype": "Small Text",
              "in_list_view": 1,
              "label": "Ingredient"
            },
            {
              "fieldname": "quantity",
              "fieldtype": "Data",
              "in_list_view": 1,
              "label": "Quantity"
            },
            {
              "fieldname": "photo",
              "fieldtype": "Attach Image",
              "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
              "label": "Photo"
            }
          ],
          "index_web_pages_for_search": 1,
          "istable": 1,
          "links": [],
          "modified": "2025-07-16 14:37:15.069235",
          "modified_by": "Administrator",
          "module": "Culinary Forms",
          "name": "Recipe Evaluation Ingredients",
          "owner": "Administrator",
          "permissions": [],
          "sort_field": "modified",
          "sort_order": "DESC",
          "states": []
        }
      },
      {
        "description": "<strong>Share photos or videos of the cooking process to bring your recipe to life</strong>",
        "fieldname": "media_uploads_section",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "media",
        "fieldtype": "Table",
        "label": "Media",
        "options": "Recipe Evaluation Media Uploads",
        "child_table": {
          "actions": [],
          "allow_rename": 1,
          "creation": "2025-06-26 13:33:15.367902",
          "doctype": "DocType",
          "editable_grid": 1,
          "engine": "InnoDB",
          "field_order": [
            "section_break_mtto",
            "photo",
            "video"
          ],
          "fields": [
            {
              "fieldname": "photo",
              "fieldtype": "Attach Image",
              "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
              "label": "Photo"
            },
            {
              "fieldname": "video",
              "fieldtype": "Attach",
              "placeholder": "https://images.unsplash.com/photo-1777400589332-fbaccdfc8500?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0",
              "label": "Video",
              "options": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 60000\n}",
              "render_rules": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 60000\n}"
            },
            {
              "fieldname": "section_break_mtto",
              "fieldtype": "Section Break",
              "options": "{\n\"type\": \"GALLERY\", \n     \"maxCount\": 1\n}",
              "render_rules": "{\n\"type\": \"GALLERY\", \n \"maxCount\": 1\n}"
            }
          ],
          "index_web_pages_for_search": 1,
          "istable": 1,
          "links": [],
          "modified": "2025-07-24 06:28:47.632072",
          "modified_by": "Administrator",
          "module": "Culinary Forms",
          "name": "Recipe Evaluation Media Uploads",
          "owner": "Administrator",
          "permissions": [],
          "sort_field": "modified",
          "sort_order": "DESC",
          "states": []
        }
      }
    ],
    "index_web_pages_for_search": 1,
    "links": [],
    "modified": "2025-10-10 03:57:48.220332",
    "modified_by": "user@mail.com",
    "module": "Culinary Forms",
    "name": "FieldTest",
    "owner": "user@mail.com",
    "permissions": [
      {
        "create": 1,
        "delete": 1,
        "email": 1,
        "export": 1,
        "print": 1,
        "read": 1,
        "report": 1,
        "role": "System Manager",
        "share": 1,
        "write": 1
      }
    ],
    "sort_field": "modified",
    "sort_order": "DESC",
    "states": []
  }
  ''';

  static const tableTest = r'''
{
  "actions": [],
  "allow_rename": 1,
  "creation": "2025-07-10 04:25:02.166743",
  "custom": 1,
  "doctype": "DocType",
  "engine": "InnoDB",
  "field_order": [
    "ingredients_and_quantities_section",
    "recipe_evaluation_ingredients"
  ],
  "fields": [
    {
      "description": "<strong>Take photo of Recipe/Formula</strong>",
      "fieldname": "ingredients_and_quantities_section",
      "fieldtype": "Section Break"
    },
    {
      "fieldname": "recipe_evaluation_ingredients",
      "fieldtype": "Table",
      "label": "Recipe Evaluation Ingredients",
      "options": "Recipe Evaluation Ingredients",
      "child_table": {
        "actions": [],
        "allow_rename": 1,
        "creation": "2025-06-26 13:04:50.708296",
        "doctype": "DocType",
        "editable_grid": 1,
        "engine": "InnoDB",
        "field_order": [
          "ingredient",
          "quantity",
          "photo"
        ],
        "fields": [
          {
            "fieldname": "ingredient",
            "fieldtype": "Data",
            "in_list_view": 1,
            "label": "Ingredient"
          },
          {
            "fieldname": "quantity",
            "fieldtype": "Data",
            "in_list_view": 1,
            "label": "Quantity"
          },
          {
            "fieldname": "photo",
            "fieldtype": "Attach Image",
            "label": "Photo"
          }
        ],
        "index_web_pages_for_search": 1,
        "istable": 1,
        "links": [],
        "modified": "2025-06-26 13:11:20.657458",
        "modified_by": "Administrator",
        "module": "Culinary Forms",
        "name": "Recipe Evaluation Ingredients",
        "owner": "Administrator",
        "permissions": [],
        "sort_field": "modified",
        "sort_order": "DESC",
        "states": []
      }
    }
  ],
  "index_web_pages_for_search": 1,
  "links": [],
  "modified": "2025-07-10 07:49:47.507216",
  "modified_by": "user@mail.com",
  "module": "Culinary Forms",
  "name": "TableTest",
  "owner": "user@mail.com",
  "permissions": [
    {
      "create": 1,
      "delete": 1,
      "email": 1,
      "export": 1,
      "print": 1,
      "read": 1,
      "report": 1,
      "role": "System Manager",
      "share": 1,
      "write": 1
    }
  ],
  "sort_field": "modified",
  "sort_order": "DESC",
  "states": []
}  
  ''';
}
