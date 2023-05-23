// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordAdapter extends TypeAdapter<DiaryRecord> {
  @override
  final int typeId = 0;

  @override
  DiaryRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryRecord(
      fields[4] as String,
      fields[1] as String,
      fields[0] as String,
      fields[2] as DateTime,
      fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.lastModified)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
