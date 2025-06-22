import 'package:flutter/material.dart';

/// エラー状態表示ウィジェット
///
/// データ取得エラー時にエラーメッセージとリトライボタンを表示
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.retryButtonText = 'Retry',
  });

  /// エラーメッセージ
  final String errorMessage;

  /// リトライボタンが押されたときのコールバック
  final VoidCallback onRetry;

  /// リトライボタンのテキスト
  final String retryButtonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(retryButtonText)),
        ],
      ),
    );
  }
}
