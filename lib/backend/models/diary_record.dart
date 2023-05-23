import 'package:hive/hive.dart';

part 'diary_record.g.dart';

@HiveType(typeId: 0)
final class DiaryRecord {
  @HiveField(0)
  String content;

  @HiveField(1)
  String title;

  @HiveField(2)
  final DateTime dateCreated;

  @HiveField(3)
  DateTime lastModified;

  @HiveField(4)
  final String id;

  DiaryRecord(
    this.id,
    this.title,
    this.content,
    this.dateCreated,
    this.lastModified,
  );
}
