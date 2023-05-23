interface class DecryptionResult {
  const DecryptionResult(this.result);

  final List<int>? result;
}

final class DecryptionSuccess extends DecryptionResult {
  DecryptionSuccess(super.result);
}

final class DecryptionFailure extends DecryptionResult {
  DecryptionFailure() : super(null);
}
