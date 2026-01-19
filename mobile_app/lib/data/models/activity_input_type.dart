import 'package:json_annotation/json_annotation.dart';

enum ActivityInputType {
  @JsonValue('number')
  number,
  @JsonValue('text')
  text,
  @JsonValue('checkbox')
  checkbox,
}
