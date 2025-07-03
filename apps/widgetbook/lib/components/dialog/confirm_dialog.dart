import 'package:flutter/material.dart';
import 'package:myapp/components/buttons/primary_button.dart';
import 'package:myapp/components/dialog/confirm_dialog.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: "Default", type: ConfirmDialog)
Widget usecaseConfirmDialog(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: PrimaryButton(
        text: "ボタン",
        onPressed: () {
          ConfirmDialog.show(
            context,
            title: "たいとる",
            messages: ["めっせーじ１", "めっせーじ２"],
            onConfirm: (isLoading) async {
              isLoading.value = true;
              await Future.delayed(Duration(seconds: 1));
              isLoading.value = false;
            },
          );
        },
      ),
    ),
  );
}
