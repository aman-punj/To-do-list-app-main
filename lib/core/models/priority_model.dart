import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'priority_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Pref extends HiveObject {
  @HiveField(0)
  late String priority;

  Pref({required this.priority});

  factory Pref.fromJson(Map<String, dynamic> json) => _$PriorityFromJson(json);

  Map<String, dynamic> toJson() => _$PriorityToJson(this);
}
