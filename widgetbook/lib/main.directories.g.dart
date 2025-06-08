// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/components/buttons/buttons.dart' as _i2;
import 'package:widgetbook_workspace/components/buttons/primary_button.dart'
    as _i3;
import 'package:widgetbook_workspace/components/buttons/scondary_button.dart'
    as _i4;
import 'package:widgetbook_workspace/components/dialog/confirm_dialog.dart'
    as _i5;
import 'package:widgetbook_workspace/features/startup/widgets/startup_error_widget.dart'
    as _i6;
import 'package:widgetbook_workspace/features/startup/widgets/startup_loading_widget.dart'
    as _i7;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'components',
    children: [
      _i1.WidgetbookFolder(
        name: 'buttons',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'Button',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i2.usecaseButton,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'PrimaryButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i3.usecasePrimaryButton,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'SecondaryButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i4.usecaseSecondaryButton,
            ),
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'dialog',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'ConfirmDialog',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i5.usecaseConfirmDialog,
            ),
          ),
        ],
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'features',
    children: [
      _i1.WidgetbookFolder(
        name: '_startup',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'widgets',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'StartupErrorWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i6.usecaseStartupErrorWidget,
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'StartupLoadingWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i7.usecaseStartupLoadingWidget,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
