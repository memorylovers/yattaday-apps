import 'package:flutter/material.dart';
import 'package:myapp/features/_authentication/presentation/widgets/login_buttons.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// LoginButtonの統合Widgetbook設定
@widgetbook.UseCase(name: 'All Variants', type: LoginButton, designLink: '')
Widget loginButtonUseCase(BuildContext context) {
  // ボタンタイプの選択
  final buttonType = context.knobs.list(
    label: 'Button Type',
    options: const ['Google', 'Apple', 'Guest', 'Email', 'Phone', 'Custom'],
    initialOption: 'Google',
  );

  // 状態の選択
  final state = context.knobs.list(
    label: 'State',
    options: const ['Normal', 'Loading', 'Disabled'],
    initialOption: 'Normal',
  );

  // アイコンのマッピング
  final iconMap = {
    'Google': Icons.login,
    'Apple': Icons.apple,
    'Guest': Icons.person_outline,
    'Email': Icons.email,
    'Phone': Icons.phone,
    'Custom': Icons.fingerprint,
  };

  // ラベルのマッピング
  final labelMap = {
    'Google': 'Googleでログイン',
    'Apple': 'Appleでサインイン',
    'Guest': 'ゲストとして続ける',
    'Email': 'メールでログイン',
    'Phone': '電話番号でログイン',
    'Custom': 'カスタムログイン',
  };

  // カスタムアイコンの選択（Customタイプの場合のみ）
  IconData selectedIcon = iconMap[buttonType]!;
  if (buttonType == 'Custom') {
    final customIconOptions = {
      'Fingerprint': Icons.fingerprint,
      'Face': Icons.face,
      'Key': Icons.key,
      'QR Code': Icons.qr_code,
      'Security': Icons.security,
    };

    final customIconKey = context.knobs.list(
      label: 'Custom Icon',
      options: customIconOptions.keys.toList(),
      initialOption: 'Fingerprint',
    );
    selectedIcon = customIconOptions[customIconKey]!;
  }

  // カスタムラベル（Customタイプの場合のみ）
  String label = labelMap[buttonType]!;
  if (buttonType == 'Custom') {
    label = context.knobs.string(
      label: 'Custom Label',
      initialValue: 'カスタムログイン',
    );
  }

  // ボタンの幅
  final buttonWidth = context.knobs.double.slider(
    label: 'Button Width',
    initialValue: 300,
    min: 200,
    max: 400,
    divisions: 20,
  );

  // 状態に応じた設定
  final isLoading = state == 'Loading';
  final isDisabled = state == 'Disabled';

  // 全てのボタンバリエーションを定義
  final buttonVariations = [
    ('Google', Icons.login, 'Googleでログイン'),
    ('Apple', Icons.apple, 'Appleでサインイン'),
    ('Guest', Icons.person_outline, 'ゲストで続ける'),
    ('Email', Icons.email, 'メールでログイン'),
    ('Phone', Icons.phone, '電話番号でログイン'),
  ];

  // カスタムボタンを追加
  if (buttonType == 'Custom') {
    buttonVariations.add(('Custom', selectedIcon, label));
  }

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 設定パネル
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Settings:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('State: $state', style: const TextStyle(fontSize: 12)),
              Text(
                'Width: ${buttonWidth.toStringAsFixed(0)}px',
                style: const TextStyle(fontSize: 12),
              ),
              if (buttonType == 'Custom')
                Text(
                  'Custom Label: $label',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 全てのボタンを縦に並べる
        ...buttonVariations.map((variation) {
          final (type, icon, btnLabel) = variation;
          final isHighlighted = type == buttonType || buttonType == 'Custom';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // ボタンタイプラベル
                SizedBox(
                  width: 80,
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isHighlighted ? FontWeight.bold : FontWeight.normal,
                      color: isHighlighted ? Colors.blue : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // ボタン本体
                Expanded(
                  child: SizedBox(
                    width: buttonWidth,
                    child: LoginButton(
                      isLoading: isLoading,
                      icon: icon,
                      label: isLoading ? 'ログイン中...' : btnLabel,
                      onPressed:
                          isDisabled
                              ? null
                              : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$type ボタンが押されました'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
