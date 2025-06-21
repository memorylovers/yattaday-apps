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
import 'package:widgetbook_workspace/components/buttons/buttons.dart' as _i9;
import 'package:widgetbook_workspace/components/buttons/primary_button.dart'
    as _i10;
import 'package:widgetbook_workspace/components/buttons/scondary_button.dart'
    as _i11;
import 'package:widgetbook_workspace/components/dialog/confirm_dialog.dart'
    as _i12;
import 'package:widgetbook_workspace/components/logo/app_logo.dart' as _i13;
import 'package:widgetbook_workspace/components/logo/apple_auth_button.dart'
    as _i14;
import 'package:widgetbook_workspace/components/logo/bubble_border.dart'
    as _i15;
import 'package:widgetbook_workspace/components/logo/dismissible_background.dart'
    as _i16;
import 'package:widgetbook_workspace/components/logo/google_auth_button.dart'
    as _i17;
import 'package:widgetbook_workspace/components/logo/unfocus_on_tap.dart'
    as _i18;
import 'package:widgetbook_workspace/components/scaffold/gradient_scaffold.dart'
    as _i19;
import 'package:widgetbook_workspace/features/_authentication/login_buttons.dart'
    as _i20;
import 'package:widgetbook_workspace/features/record_items/record_item_card.dart'
    as _i21;
import 'package:widgetbook_workspace/features/record_items/record_item_form.dart'
    as _i22;
import 'package:widgetbook_workspace/features/startup/startup_error_widget.dart'
    as _i23;
import 'package:widgetbook_workspace/features/startup/startup_loading_widget.dart'
    as _i24;
import 'package:widgetbook_workspace/pages/login_page.dart' as _i2;
import 'package:widgetbook_workspace/pages/payment_page.dart' as _i3;
import 'package:widgetbook_workspace/pages/record_items_create_page.dart'
    as _i4;
import 'package:widgetbook_workspace/pages/record_items_detail_page.dart'
    as _i5;
import 'package:widgetbook_workspace/pages/record_items_edit_page.dart' as _i6;
import 'package:widgetbook_workspace/pages/record_items_list_page.dart' as _i7;
import 'package:widgetbook_workspace/pages/settings_page.dart' as _i8;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookCategory(
    name: 'pages',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'LoginPage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i2.loginPageUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'PaymentPage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i3.buildPaymentPageUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'RecordItemsCreatePage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i4.recordItemsCreatePageDefault,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'RecordItemsDetailPage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i5.recordItemsDetailPageDefault,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'RecordItemsEditPage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i6.buildRecordItemsEditPageDefault,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'RecordItemsListPage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i7.recordItemsListPageDefault,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'SettingsPage',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i8.buildSettingsPageUseCase,
        ),
      ),
    ],
  ),
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
              builder: _i9.usecaseButton,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'PrimaryButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i10.usecasePrimaryButton,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'SecondaryButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i11.usecaseSecondaryButton,
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
              builder: _i12.usecaseConfirmDialog,
            ),
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'logo',
        children: [
          _i1.WidgetbookComponent(
            name: 'AppLogo',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Custom Color',
                builder: _i13.customColorAppLogo,
              ),
              _i1.WidgetbookUseCase(
                name: 'Custom Size',
                builder: _i13.customSizeAppLogo,
              ),
              _i1.WidgetbookUseCase(
                name: 'Custom Width and Height',
                builder: _i13.customWidthHeightAppLogo,
              ),
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i13.defaultAppLogo,
              ),
              _i1.WidgetbookUseCase(
                name: 'Different Backgrounds',
                builder: _i13.differentBackgroundsAppLogo,
              ),
              _i1.WidgetbookUseCase(
                name: 'Login Page Example',
                builder: _i13.loginPageExampleAppLogo,
              ),
            ],
          ),
          _i1.WidgetbookComponent(
            name: 'AppleAuthButton',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Custom Label',
                builder: _i14.customLabelAppleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Dark Theme',
                builder: _i14.darkThemeAppleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i14.defaultAppleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Disabled',
                builder: _i14.disabledAppleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Multiple Sizes',
                builder: _i14.multipleSizesAppleAuthButton,
              ),
            ],
          ),
          _i1.WidgetbookComponent(
            name: 'BubbleBorder',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'All Directions',
                builder: _i15.allDirectionsBubbleBorder,
              ),
              _i1.WidgetbookUseCase(
                name: 'Chat Message Example',
                builder: _i15.chatMessageBubbleBorder,
              ),
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i15.defaultBubbleBorder,
              ),
              _i1.WidgetbookUseCase(
                name: 'Interactive Direction',
                builder: _i15.interactiveBubbleBorder,
              ),
              _i1.WidgetbookUseCase(
                name: 'With and Without Padding',
                builder: _i15.paddingBubbleBorder,
              ),
            ],
          ),
          _i1.WidgetbookComponent(
            name: 'DismissibleBackground',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Custom Colors',
                builder: _i16.customColorsDismissibleBackground,
              ),
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i16.defaultDismissibleBackground,
              ),
              _i1.WidgetbookUseCase(
                name: 'Different Alignments',
                builder: _i16.differentAlignmentsDismissibleBackground,
              ),
              _i1.WidgetbookUseCase(
                name: 'Interactive Example',
                builder: _i16.interactiveDismissibleBackground,
              ),
              _i1.WidgetbookUseCase(
                name: 'List Item Example',
                builder: _i16.listItemDismissibleBackground,
              ),
              _i1.WidgetbookUseCase(
                name: 'With Border Radius',
                builder: _i16.borderRadiusDismissibleBackground,
              ),
            ],
          ),
          _i1.WidgetbookComponent(
            name: 'GoogleAuthButton',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Custom Label',
                builder: _i17.customLabelGoogleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Dark Theme',
                builder: _i17.darkThemeGoogleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i17.defaultGoogleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Disabled',
                builder: _i17.disabledGoogleAuthButton,
              ),
              _i1.WidgetbookUseCase(
                name: 'Multiple Sizes',
                builder: _i17.multipleSizesGoogleAuthButton,
              ),
            ],
          ),
          _i1.WidgetbookComponent(
            name: 'UnfocusOnTap',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i18.defaultUnfocusOnTap,
              ),
              _i1.WidgetbookUseCase(
                name: 'Form Example',
                builder: _i18.formExampleUnfocusOnTap,
              ),
              _i1.WidgetbookUseCase(
                name: 'Multiple Input Types',
                builder: _i18.multipleInputTypesUnfocusOnTap,
              ),
              _i1.WidgetbookUseCase(
                name: 'With Background Color',
                builder: _i18.backgroundColorUnfocusOnTap,
              ),
            ],
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'scaffold',
        children: [
          _i1.WidgetbookComponent(
            name: 'GradientScaffold',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Complex Example',
                builder: _i19.complexExampleGradientScaffold,
              ),
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i19.defaultGradientScaffold,
              ),
              _i1.WidgetbookUseCase(
                name: 'With Actions',
                builder: _i19.withActionsGradientScaffold,
              ),
              _i1.WidgetbookUseCase(
                name: 'With FAB',
                builder: _i19.withFABGradientScaffold,
              ),
              _i1.WidgetbookUseCase(
                name: 'With Title',
                builder: _i19.withTitleGradientScaffold,
              ),
              _i1.WidgetbookUseCase(
                name: 'With White Container',
                builder: _i19.withWhiteContainerGradientScaffold,
              ),
            ],
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
          _i1.WidgetbookLeafComponent(
            name: 'LoginButton',
            useCase: _i1.WidgetbookUseCase(
              name: 'All Variants',
              builder: _i20.loginButtonUseCase,
              designLink: '',
            ),
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'record_items',
        children: [
          _i1.WidgetbookComponent(
            name: 'RecordItemCard',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i21.recordItemCardDefault,
              ),
              _i1.WidgetbookUseCase(
                name: 'Minimal',
                builder: _i21.recordItemCardMinimal,
              ),
              _i1.WidgetbookUseCase(
                name: 'Without Description',
                builder: _i21.recordItemCardWithoutDescription,
              ),
              _i1.WidgetbookUseCase(
                name: 'Without Unit',
                builder: _i21.recordItemCardWithoutUnit,
              ),
            ],
          ),
          _i1.WidgetbookComponent(
            name: 'RecordItemForm',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i22.recordItemFormDefault,
              ),
              _i1.WidgetbookUseCase(
                name: 'Prefilled Form',
                builder: _i22.recordItemFormPrefilled,
              ),
              _i1.WidgetbookUseCase(
                name: 'With Delay',
                builder: _i22.recordItemFormWithDelay,
              ),
              _i1.WidgetbookUseCase(
                name: 'With Error',
                builder: _i22.recordItemFormWithError,
              ),
              _i1.WidgetbookUseCase(
                name: 'Without Callbacks',
                builder: _i22.recordItemFormWithoutCallbacks,
              ),
            ],
          ),
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'startup',
        children: [
          _i1.WidgetbookLeafComponent(
            name: 'StartupErrorWidget',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i23.usecaseStartupErrorWidget,
            ),
          ),
          _i1.WidgetbookLeafComponent(
            name: 'StartupLoadingWidget',
            useCase: _i1.WidgetbookUseCase(
              name: 'Default',
              builder: _i24.usecaseStartupLoadingWidget,
            ),
          ),
        ],
      ),
    ],
  ),
];
