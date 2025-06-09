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
import 'package:widgetbook_workspace/features/authentication/presentation/pages/login_page.dart'
    as _i6;
import 'package:widgetbook_workspace/features/authentication/presentation/widgets/login_buttons.dart'
    as _i7;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_create_page.dart'
    as _i10;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_edit_page.dart'
    as _i11;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_list_page.dart'
    as _i12;
import 'package:widgetbook_workspace/features/record_items/presentation/widgets/record_item_card.dart'
    as _i13;
import 'package:widgetbook_workspace/features/record_items/presentation/widgets/record_item_form.dart'
    as _i14;
import 'package:widgetbook_workspace/features/startup/widgets/startup_error_widget.dart'
    as _i8;
import 'package:widgetbook_workspace/features/startup/widgets/startup_loading_widget.dart'
    as _i9;

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
        name: '_authentication',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookComponent(
                name: 'LoginPage',
                useCases: [
                  _i1.WidgetbookUseCase(
                    name: 'Dark Mode',
                    builder: _i6.darkModeLoginPageUseCase,
                    designLink: '',
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Default',
                    builder: _i6.defaultLoginPageUseCase,
                    designLink: '',
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Large Text',
                    builder: _i6.largeTextLoginPageUseCase,
                    designLink: '',
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Loading State',
                    builder: _i6.loadingLoginPageUseCase,
                    designLink: '',
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Tablet Size',
                    builder: _i6.tabletLoginPageUseCase,
                    designLink: '',
                  ),
                ],
              ),
              _i1.WidgetbookFolder(
                name: 'widgets',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'AnonymousLoginButton',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i7.anonymousLoginButtonUseCase,
                      designLink: '',
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'AppleLoginButton',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i7.appleLoginButtonUseCase,
                      designLink: '',
                    ),
                  ),
                  _i1.WidgetbookComponent(
                    name: 'GoogleLoginButton',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'All Variants',
                        builder: _i7.allLoginButtonsUseCase,
                        designLink: '',
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i7.googleLoginButtonUseCase,
                        designLink: '',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
                      builder: _i8.usecaseStartupErrorWidget,
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'StartupLoadingWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i9.usecaseStartupLoadingWidget,
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
                        builder: _i10.recordItemsCreatePageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Empty UserID',
                        builder: _i10.recordItemsCreatePageEmptyUserId,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Long UserID',
                        builder: _i10.recordItemsCreatePageLongUserId,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Error',
                        builder: _i10.recordItemsCreatePageWithError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Loading',
                        builder: _i10.recordItemsCreatePageWithLoading,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemsEditPage',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i11.buildRecordItemsEditPageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Loading State Test',
                        builder: _i11.buildRecordItemsEditPageLoading,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Update Error',
                        builder: _i11.buildRecordItemsEditPageError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Long Text',
                        builder: _i11.buildRecordItemsEditPageLongText,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Minimal Data',
                        builder: _i11.buildRecordItemsEditPageMinimal,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemsListPage',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i12.recordItemsListPageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Empty List',
                        builder: _i12.recordItemsListPageEmpty,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Error State',
                        builder: _i12.recordItemsListPageError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Loading State',
                        builder: _i12.recordItemsListPageLoading,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Many Items',
                        builder: _i12.recordItemsListPageManyItems,
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
                        builder: _i13.recordItemCardDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Minimal',
                        builder: _i13.recordItemCardMinimal,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Description',
                        builder: _i13.recordItemCardWithoutDescription,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Unit',
                        builder: _i13.recordItemCardWithoutUnit,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemForm',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i14.recordItemFormDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Prefilled Form',
                        builder: _i14.recordItemFormPrefilled,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Delay',
                        builder: _i14.recordItemFormWithDelay,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Error',
                        builder: _i14.recordItemFormWithError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Callbacks',
                        builder: _i14.recordItemFormWithoutCallbacks,
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
