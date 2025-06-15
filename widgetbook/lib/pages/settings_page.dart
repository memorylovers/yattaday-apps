import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myapp/features/account/presentation/settings_page.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: SettingsPage, path: '[pages]')
Widget buildSettingsPageUseCase(BuildContext context) {
  return ProviderScope(child: const SettingsPage());
}
