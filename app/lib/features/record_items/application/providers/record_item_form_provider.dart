import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../use_cases/create_record_item_usecase.dart';
import '../use_cases/update_record_item_usecase.dart';
import 'record_items_provider.dart';

part 'record_item_form_provider.freezed.dart';

/// 記録項目フォームの状態
@freezed
class RecordItemFormState with _$RecordItemFormState {
  const factory RecordItemFormState({
    @Default('') String title,
    @Default('') String description,
    @Default('') String unit,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _RecordItemFormState;

  const RecordItemFormState._();

  /// フォームが有効かどうか
  bool get isValid => title.trim().isNotEmpty;
}

/// CreateRecordItemUseCaseのプロバイダ
final createRecordItemUseCaseProvider = Provider<CreateRecordItemUseCase>((
  ref,
) {
  final repository = ref.watch(recordItemRepositoryProvider);
  return CreateRecordItemUseCase(repository);
});

/// UpdateRecordItemUseCaseのプロバイダ
final updateRecordItemUseCaseProvider = Provider<UpdateRecordItemUseCase>((
  ref,
) {
  final repository = ref.watch(recordItemRepositoryProvider);
  return UpdateRecordItemUseCase(repository);
});

/// 記録項目フォームの状態管理プロバイダ
final recordItemFormProvider =
    StateNotifierProvider<RecordItemFormNotifier, RecordItemFormState>((ref) {
      final createUseCase = ref.watch(createRecordItemUseCaseProvider);
      final updateUseCase = ref.watch(updateRecordItemUseCaseProvider);
      return RecordItemFormNotifier(createUseCase, updateUseCase);
    });

/// 記録項目フォームの状態管理クラス
class RecordItemFormNotifier extends StateNotifier<RecordItemFormState> {
  final CreateRecordItemUseCase _createUseCase;
  final UpdateRecordItemUseCase _updateUseCase;

  RecordItemFormNotifier(this._createUseCase, this._updateUseCase)
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
      // 記録項目を作成
      await _createUseCase.execute(
        userId: userId,
        title: state.title,
        description: state.description.isEmpty ? null : state.description,
        unit: state.unit.isEmpty ? null : state.unit,
      );

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
      // 記録項目を更新
      await _updateUseCase.execute(
        userId: userId,
        recordItemId: recordItemId,
        title: state.title,
        description: state.description,
        unit: state.unit,
      );

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
