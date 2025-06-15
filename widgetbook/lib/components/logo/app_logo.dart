import 'package:flutter/material.dart';
import 'package:myapp/components/logo/app_logo.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// AppLogoのWidgetbook用ストーリー
@widgetbook.UseCase(name: 'Default', type: AppLogo, path: 'components/logo')
Widget defaultAppLogo(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: const Center(child: AppLogo()),
  );
}

@widgetbook.UseCase(name: 'Custom Size', type: AppLogo, path: 'components/logo')
Widget customSizeAppLogo(BuildContext context) {
  final size = context.knobs.double.slider(
    label: 'Size',
    initialValue: 200,
    min: 50,
    max: 400,
  );

  return Container(
    color: Colors.grey[200],
    child: Center(child: AppLogo(size: size)),
  );
}

@widgetbook.UseCase(
  name: 'Custom Color',
  type: AppLogo,
  path: 'components/logo',
)
Widget customColorAppLogo(BuildContext context) {
  final colorOptions = {
    'White': Colors.white,
    'Black': Colors.black,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Red': Colors.red,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
  };

  final selectedColor = context.knobs.list(
    label: 'Color',
    options: colorOptions.keys.toList(),
    initialOption: 'White',
  );

  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF5DD3DC),
          const Color(0xFF7EDBB7),
          const Color(0xFFF5D563),
        ],
      ),
    ),
    child: Center(
      child: AppLogo(size: 200, color: colorOptions[selectedColor]),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Width and Height',
  type: AppLogo,
  path: 'components/logo',
)
Widget customWidthHeightAppLogo(BuildContext context) {
  final width = context.knobs.double.slider(
    label: 'Width',
    initialValue: 150,
    min: 50,
    max: 300,
  );

  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 100,
    min: 50,
    max: 300,
  );

  return Container(
    color: Colors.grey[200],
    child: Center(child: AppLogo(width: width, height: height)),
  );
}

@widgetbook.UseCase(
  name: 'Different Backgrounds',
  type: AppLogo,
  path: 'components/logo',
)
Widget differentBackgroundsAppLogo(BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: Container(
          color: Colors.white,
          child: const Center(child: AppLogo(size: 100, color: Colors.black)),
        ),
      ),
      Expanded(
        child: Container(
          color: Colors.black,
          child: const Center(child: AppLogo(size: 100, color: Colors.white)),
        ),
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          ),
          child: const Center(child: AppLogo(size: 100, color: Colors.white)),
        ),
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Login Page Example',
  type: AppLogo,
  path: 'components/logo',
)
Widget loginPageExampleAppLogo(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF5DD3DC),
          const Color(0xFF7EDBB7),
          const Color(0xFFF5D563),
        ],
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLogo(size: 200, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            'YattaDay',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '毎日の記録を簡単に',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    ),
  );
}
