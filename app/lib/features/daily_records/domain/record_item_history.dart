import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/json_converter/datetime_converter.dart';

part 'record_item_history.freezed.dart';
part 'record_item_history.g.dart';

/// 記録項目の履歴モデル
@freezed
class RecordItemHistory with _$RecordItemHistory {
  const factory RecordItemHistory({
    /// 日次記録ID（uuid v7）
    required String id,

    /// ユーザーID
    required String userId,

    /// 記録日（yyyy-MM-dd形式）
    required String date,

    /// 記録項目ID
    required String recordItemId,

    /// メモ（将来拡張用）
    String? note,

    /// 作成日時
    @DateTimeConverter() required DateTime createdAt,

    /// 最終更新日時
    @DateTimeConverter() required DateTime updatedAt,
  }) = _RecordItemHistory;

  factory RecordItemHistory.fromJson(Map<String, dynamic> json) =>
      _$RecordItemHistoryFromJson(json);

  /// firestoreのcollection path
  static String collectionPath(String userId, String recordItemId) =>
      "users/$userId/recordItems/$recordItemId/histories";

  static FromFirestore<RecordItemHistory> get fromFirestore =>
      (snapshot, _) => RecordItemHistory.fromJson(snapshot.data() ?? {});

  static ToFirestore<RecordItemHistory> get toFirestore =>
      (data, _) => data.toJson();
}

extension RecordItemHistoryExtension on RecordItemHistory {
  /// 日付をDateTimeに変換
  DateTime get dateTime => DateTime.parse(date);
}
