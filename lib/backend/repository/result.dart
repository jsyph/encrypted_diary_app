import '../models/diary_record.dart';

interface class AccessResult {
  final List<DiaryRecord>? result;

  AccessResult(this.result);
}

final class AccessResultSuccess extends AccessResult {
  AccessResultSuccess(super.result);
}

final class AccessResultFailure extends AccessResult {
  AccessResultFailure() : super(null);
}
