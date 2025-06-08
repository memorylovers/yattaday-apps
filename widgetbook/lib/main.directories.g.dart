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
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_create_page.dart'
    as _i8;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_list_page.dart'
    as _i9;
import 'package:widgetbook_workspace/features/record_items/presentation/widgets/record_item_card.dart'
    as _i10;
import 'package:widgetbook_workspace/features/record_items/presentation/widgets/record_item_form.dart'
    as _i11;
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
      _i1.WidgetbookFolder(
        name: 'record_items',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookFolder(
                name: 'pages',
                children: [
                  _i1.WidgetbookComponent(
                    name: 'RecordItemsCreatePage',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i8.recordItemsCreatePageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Empty UserID',
                        builder: _i8.recordItemsCreatePageEmptyUserId,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Long UserID',
                        builder: _i8.recordItemsCreatePageLongUserId,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Error',
                        builder: _i8.recordItemsCreatePageWithError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Loading',
                        builder: _i8.recordItemsCreatePageWithLoading,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemsListPage',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i9.recordItemsListPageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Empty List',
                        builder: _i9.recordItemsListPageEmpty,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Error State',
                        builder: _i9.recordItemsListPageError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Loading State',
                        builder: _i9.recordItemsListPageLoading,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Many Items',
                        builder: _i9.recordItemsListPageManyItems,
                      ),
                    ],
                  ),
                ],
              ),
              _i1.WidgetbookFolder(
                name: 'widgets',
                children: [
                  _i1.WidgetbookComponent(
                    name: 'RecordItemCard',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i10.recordItemCardDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Minimal',
                        builder: _i10.recordItemCardMinimal,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Description',
                        builder: _i10.recordItemCardWithoutDescription,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Unit',
                        builder: _i10.recordItemCardWithoutUnit,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemForm',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i11.recordItemFormDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Prefilled Form',
                        builder: _i11.recordItemFormPrefilled,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Delay',
                        builder: _i11.recordItemFormWithDelay,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Error',
                        builder: _i11.recordItemFormWithError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Callbacks',
                        builder: _i11.recordItemFormWithoutCallbacks,
                      ),
                    ],
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
