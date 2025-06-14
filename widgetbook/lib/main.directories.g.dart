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
import 'package:widgetbook_workspace/features/_payment/presentation/pages/payment_page.dart'
    as _i8;
import 'package:widgetbook_workspace/features/account/presentation/settings_page.dart'
    as _i11;
import 'package:widgetbook_workspace/features/authentication/presentation/pages/login_page.dart'
    as _i6;
import 'package:widgetbook_workspace/features/authentication/presentation/widgets/login_buttons.dart'
    as _i7;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_create_page.dart'
    as _i12;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_detail_page.dart'
    as _i13;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_edit_page.dart'
    as _i14;
import 'package:widgetbook_workspace/features/record_items/presentation/pages/record_items_list_page.dart'
    as _i15;
import 'package:widgetbook_workspace/features/record_items/presentation/widgets/record_item_card.dart'
    as _i16;
import 'package:widgetbook_workspace/features/record_items/presentation/widgets/record_item_form.dart'
    as _i17;
import 'package:widgetbook_workspace/features/startup/widgets/startup_error_widget.dart'
    as _i9;
import 'package:widgetbook_workspace/features/startup/widgets/startup_loading_widget.dart'
    as _i10;

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
              _i1.WidgetbookLeafComponent(
                name: 'LoginPage',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Default',
                  builder: _i6.loginPageUseCase,
                ),
              ),
              _i1.WidgetbookFolder(
                name: 'widgets',
                children: [
                  _i1.WidgetbookLeafComponent(
                    name: 'LoginButton',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'All Variants',
                      builder: _i7.loginButtonUseCase,
                      designLink: '',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: '_payment',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'PaymentPage',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Default',
                  builder: _i8.buildPaymentPageUseCase,
                ),
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
                      builder: _i9.usecaseStartupErrorWidget,
                    ),
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'StartupLoadingWidget',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i10.usecaseStartupLoadingWidget,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'account',
        children: [
          _i1.WidgetbookFolder(
            name: 'presentation',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'SettingsPage',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Default',
                  builder: _i11.buildSettingsPageUseCase,
                ),
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
                        builder: _i12.recordItemsCreatePageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Empty UserID',
                        builder: _i12.recordItemsCreatePageEmptyUserId,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Long UserID',
                        builder: _i12.recordItemsCreatePageLongUserId,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Error',
                        builder: _i12.recordItemsCreatePageWithError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Loading',
                        builder: _i12.recordItemsCreatePageWithLoading,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemsDetailPage',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i13.recordItemsDetailPageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Error',
                        builder: _i13.recordItemsDetailPageError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Loading',
                        builder: _i13.recordItemsDetailPageLoading,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Not Found',
                        builder: _i13.recordItemsDetailPageNotFound,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Today Record',
                        builder: _i13.recordItemsDetailPageWithTodayRecord,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemsEditPage',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i14.buildRecordItemsEditPageDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Loading State Test',
                        builder: _i14.buildRecordItemsEditPageLoading,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Update Error',
                        builder: _i14.buildRecordItemsEditPageError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Long Text',
                        builder: _i14.buildRecordItemsEditPageLongText,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Minimal Data',
                        builder: _i14.buildRecordItemsEditPageMinimal,
                      ),
                    ],
                  ),
                  _i1.WidgetbookLeafComponent(
                    name: 'RecordItemsListPage',
                    useCase: _i1.WidgetbookUseCase(
                      name: 'Default',
                      builder: _i15.recordItemsListPageDefault,
                    ),
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
                        builder: _i16.recordItemCardDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Minimal',
                        builder: _i16.recordItemCardMinimal,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Description',
                        builder: _i16.recordItemCardWithoutDescription,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Unit',
                        builder: _i16.recordItemCardWithoutUnit,
                      ),
                    ],
                  ),
                  _i1.WidgetbookComponent(
                    name: 'RecordItemForm',
                    useCases: [
                      _i1.WidgetbookUseCase(
                        name: 'Default',
                        builder: _i17.recordItemFormDefault,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Prefilled Form',
                        builder: _i17.recordItemFormPrefilled,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Delay',
                        builder: _i17.recordItemFormWithDelay,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'With Error',
                        builder: _i17.recordItemFormWithError,
                      ),
                      _i1.WidgetbookUseCase(
                        name: 'Without Callbacks',
                        builder: _i17.recordItemFormWithoutCallbacks,
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
