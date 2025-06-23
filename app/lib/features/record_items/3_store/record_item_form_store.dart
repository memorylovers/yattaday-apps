import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ulid4d/ulid4d.dart';

import '../1_models/record_item.dart';
import '../2_repository/record_item_query_repository.dart';
import '../2_repository/record_item_command_repository.dart';
import 'record_items_store.dart';
import 'record_item_crud_store.dart';

part 'record_item_form_store.freezed.dart';

/// 記録項目フォームの状態
@freezed
class RecordItemFormState with _$RecordItemFormState {
  const factory RecordItemFormState({
    @Default('') String title,
    @Default('') String description,
    @Default('📝') String icon,
    @Default('') String unit,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _RecordItemFormState;

  const RecordItemFormState._();

  /// フォームが有効かどうか
  bool get isValid => title.trim().isNotEmpty;
}


/// 記録項目フォームの状態管理プロバイダ
final recordItemFormProvider =
    StateNotifierProvider<RecordItemFormNotifier, RecordItemFormState>((ref) {
      final queryRepository = ref.watch(recordItemQueryRepositoryProvider);
      final commandRepository = ref.watch(recordItemCommandRepositoryProvider);
      return RecordItemFormNotifier(queryRepository, commandRepository);
    });

/// 記録項目フォームの状態管理クラス
class RecordItemFormNotifier extends StateNotifier<RecordItemFormState> {
  final IRecordItemQueryRepository _queryRepository;
  final IRecordItemCommandRepository _commandRepository;

  RecordItemFormNotifier(this._queryRepository, this._commandRepository)
    : super(const RecordItemFormState());

  /// タイトルを更新
  void updateTitle(String title) {
    state = state.copyWith(title: title, errorMessage: null);
  }

  /// 説明を更新
  void updateDescription(String description) {
    state = state.copyWith(description: description, errorMessage: null);
  }

  /// 単位を更新
  void updateUnit(String unit) {
    state = state.copyWith(unit: unit, errorMessage: null);
  }

  /// アイコンを更新
  void updateIcon(String icon) {
    state = state.copyWith(icon: icon, errorMessage: null);
  }

  /// フォームをリセット
  void reset() {
    state = const RecordItemFormState();
  }

  /// エラーメッセージをクリア
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 記録項目を作成
  Future<bool> submit(String userId) async {
    // バリデーション
    if (userId.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'ユーザーIDが無効です');
      return false;
    }

    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'タイトルを入力してください');
      return false;
    }

    // submission開始
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // 新しいソート順序を取得
      final sortOrder = await _queryRepository.getNextSortOrder(userId);
      
      // 記録項目を作成
      final recordItem = RecordItem(
        id: ULID.randomULID(),
        userId: userId,
        title: state.title,
        description: state.description.isEmpty ? null : state.description,
        icon: state.icon,
        unit: state.unit.isEmpty ? null : state.unit,
        sortOrder: sortOrder,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _commandRepository.create(recordItem);

      // 成功時はフォームをリセット
      state = const RecordItemFormState();
      return true;
    } catch (error) {
      // エラー時はエラーメッセージを設定
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  /// 記録項目を更新
  Future<bool> update({
    required String userId,
    required String recordItemId,
  }) async {
    // バリデーション
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'タイトルを入力してください');
      return false;
    }

    // submission開始
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // 既存の記録項目を取得
      final existingItem = await _queryRepository.getById(userId, recordItemId);
      if (existingItem == null) {
        throw Exception('記録項目が見つかりません');
      }
      
      // 記録項目を更新
      final updatedItem = existingItem.copyWith(
        title: state.title,
        description: state.description.isEmpty ? null : state.description,
        icon: state.icon,
        unit: state.unit.isEmpty ? null : state.unit,
        updatedAt: DateTime.now(),
      );
      
      await _commandRepository.update(updatedItem);

      // 成功時は処理完了状態にする（フォームはリセットしない）
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (error) {
      // エラー時はエラーメッセージを設定
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }
}
