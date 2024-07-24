part of 'configs.dart';

class DataSelection extends Selection {
  const DataSelection.empty() : super.empty();

  const DataSelection.from(Object super.snapshot, super.type) : super.from();

  const DataSelection.endAt(super.values) : super.endAt();

  const DataSelection.endAtDocument(super.snapshot) : super.endAtDocument();

  const DataSelection.endBefore(super.values) : super.endBefore();

  const DataSelection.endBeforeDocument(super.snapshot)
      : super.endBeforeDocument();

  const DataSelection.startAfter(super.values) : super.startAfter();

  const DataSelection.startAfterDocument(super.snapshot)
      : super.startAfterDocument();

  const DataSelection.startAt(super.values) : super.startAt();

  const DataSelection.startAtDocument(super.snapshot) : super.startAtDocument();
}
