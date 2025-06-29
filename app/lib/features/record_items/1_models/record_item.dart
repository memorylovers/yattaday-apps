import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/json_converter/datetime_converter.dart';

part 'record_item.freezed.dart';
part 'record_item.g.dart';

/// 記録項目のモデル
@freezed
class RecordItem with _$RecordItem {
  const factory RecordItem({
    /// 記録項目ID（ULID）
    required String id,

    /// 所有者のユーザーID
    required String userId,

    /// 記録項目の名前
    required String title,

    /// 記録項目の説明（オプション）
    String? description,

    /// 記録項目のアイコン（絵文字）
    required String icon,

    /// 単位（例：回、分、ページなど）
    String? unit,

    /// 表示順序
    required int sortOrder,

    /// 作成日時
    @DateTimeConverter() required DateTime createdAt,

    /// 最終更新日時
    @DateTimeConverter() required DateTime updatedAt,
  }) = _RecordItem;

  factory RecordItem.fromJson(Map<String, dynamic> json) =>
      _$RecordItemFromJson(json);
}
