// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriorityAdapter extends TypeAdapter<Pref> {
  @override
  final int typeId = 1;

  @override
  Pref read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pref(
      priority: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Pref obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pref _$PriorityFromJson(Map<String, dynamic> json) => Pref(
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$PriorityToJson(Pref instance) => <String, dynamic>{
      'priority': instance.priority,
    };
