import 'dart:convert';

import 'package:adeptannotations/adeptannotations.dart';
import 'package:equatable/equatable.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'render_rules.g.dart';

@JsonSerializable()
@CopyWith()
class RenderRules with Equatable {
  final String? type;

  RenderRules({this.type});

  @override
  List<Object?> get props => [type];

  static RenderRules? tryFromJsonString(String? json) {
    try {
      if (json.isEmpty) return null;
      return RenderRules.fromJsonString(json ?? '');
    } catch (_) {}
    return null;
  }

  Map<String, dynamic> toJson() => _$RenderRulesToJson(this);

  factory RenderRules.fromJson(Map<String, dynamic> json) =>
      _$RenderRulesFromJson(json);

  factory RenderRules.fromJsonString(String json) =>
      RenderRules.fromJson(jsonDecode(json));
}
