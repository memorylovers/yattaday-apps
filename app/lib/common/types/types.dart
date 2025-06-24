import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.freezed.dart';

/// FirestoreのDocumentReferenceとそのdataのpair
typedef DocumentPair<T> = ({DocumentReference<T> reference, T data});

/// ページング用のレスポンスデータ
@freezed
class PageResponse<T> with _$PageResponse<T> {
  const PageResponse._();
  const factory PageResponse({
    required List<T> items,
    required int perPage,
    required bool hasNext,
  }) = _PageResponse<T>;
}
