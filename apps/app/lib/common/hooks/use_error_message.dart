import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/snack_bar_handler.dart';

/// エラーメッセージを監視してSnackBarを表示するカスタムフック
void useErrorMessage(String? errorMessage, BuildContext context) {
  useEffect(() {
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          SnackBarHandler.showError(context, message: errorMessage);
        }
      });
    }
    return null;
  }, [errorMessage]);
}
