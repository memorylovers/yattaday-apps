import 'package:flutter/material.dart';

// opacity 60 = 9A
class AppColors {
  static final MaterialColor primary = Colors.teal;

  static const Color white = Color(0xFFE9ECF0);
  static const Color white_60A = Color(0x9AE9ECF0);
  static const Color black = Color(0xFF141414);
  static const Color black_60A = Color(0x9A141414);
  static const Color black_40A = Color(0x65141414);
}

final colorSchemeLight = ColorScheme.fromSeed(seedColor: AppColors.primary);

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF30C2D8), // シアン（主色）
  onPrimary: Color(0xFFFFFFFF), // 白（主色上の文字など）
  primaryContainer: Color(0xFFBEEFF7),
  onPrimaryContainer: Color(0xFF00363F),

  secondary: Color(0xFF96D2B4), // ミント（副色）
  onSecondary: Color(0xFF003826),
  secondaryContainer: Color(0xFFD8F8E2),
  onSecondaryContainer: Color(0xFF082E1B),

  tertiary: Color(0xFFF8DC5B), // イエロー（補助色）
  onTertiary: Color(0xFF3D3200),
  tertiaryContainer: Color(0xFFFFF4C2),
  onTertiaryContainer: Color(0xFF453A00),

  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),

  surface: Color(0xFFFFFFFF), // サーフェス（カードやシート）
  onSurface: Color(0xFF1A1C1E),
  surfaceContainerHighest: Color(0xFFF0F0F0),
  onSurfaceVariant: Color(0xFF44474F),

  outline: Color(0xFFB3B3B3), // 枠線・仕切り線
  shadow: Color(0xFF000000), // 影
  inverseSurface: Color(0xFF2F3133),
  onInverseSurface: Color(0xFFF1F0F0),
  inversePrimary: Color(0xFF006877),
);
