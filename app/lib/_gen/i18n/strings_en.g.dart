///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final i18n = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
  late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
  late final TranslationsErrorEn error = TranslationsErrorEn.internal(_root);
  late final TranslationsLoginEn login = TranslationsLoginEn.internal(_root);
  late final TranslationsSettingsEn settings = TranslationsSettingsEn.internal(
    _root,
  );
  late final TranslationsPaymentEn payment = TranslationsPaymentEn.internal(
    _root,
  );
  late final TranslationsForceUpdateEn forceUpdate =
      TranslationsForceUpdateEn.internal(_root);
  late final TranslationsRecordItemsEn recordItems =
      TranslationsRecordItemsEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
  TranslationsAppEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'YattaDay';
}

// Path: common
class TranslationsCommonEn {
  TranslationsCommonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get retry => 'Retry';
  String get ok => 'OK';
  String get cancel => 'Cancel';
  String get save => 'Save';
  String get edit => 'Edit';
  String get delete => 'Delete';
  String get add => 'Add';
  String get create => 'Create';
}

// Path: error
class TranslationsErrorEn {
  TranslationsErrorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get unexpected => 'An Unexpected Error has occurred';
}

// Path: login
class TranslationsLoginEn {
  TranslationsLoginEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Login';
  String get googleSignIn => 'Sign in with Google';
  String get appleSignIn => 'Sign in with Apple';
  String get anonymousSignIn => 'Continue as Guest';
}

// Path: settings
class TranslationsSettingsEn {
  TranslationsSettingsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Settings';
  String get account => 'Account';
  String get payment => 'Subscription';
  String get contact => 'Contact Us';
  String get planManagement => 'Plan Management';
  String get currentPlan => 'Current Plan';
  String get free => 'Free';
  String get profileEdit => 'Edit Profile';
  String get appSettings => 'App Settings';
  String get notifications => 'Notifications';
  String get notificationsDesc => 'Customize reminder notifications';
  String get theme => 'Theme';
  String get lightMode => 'Light Mode';
  String get language => 'Language';
  String get japanese => 'Japanese';
  String get support => 'Support';
  String get help => 'Help';
  String get contactUs => 'Contact Us';
  String get terms => 'Terms of Service';
  String get privacy => 'Privacy Policy';
  String get logout => 'Logout';
  String get userName => 'Taro Tanaka';
  String get userEmail => 'tanaka@example.com';
}

// Path: payment
class TranslationsPaymentEn {
  TranslationsPaymentEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Subscription';
  String get description => 'Upgrade to premium for more features';
  String get selectPlan => 'Select Plan';
  late final TranslationsPaymentHeaderEn header =
      TranslationsPaymentHeaderEn.internal(_root);
  String currentPlan({required Object plan}) => 'Current Plan: ${plan}';
  late final TranslationsPaymentPlansEn plans =
      TranslationsPaymentPlansEn.internal(_root);
  late final TranslationsPaymentPriceEn price =
      TranslationsPaymentPriceEn.internal(_root);
  late final TranslationsPaymentButtonsEn buttons =
      TranslationsPaymentButtonsEn.internal(_root);
}

// Path: forceUpdate
class TranslationsForceUpdateEn {
  TranslationsForceUpdateEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Please Update';
  String get desc =>
      'A new version of the app is available. Please update from the store.';
  String get label => 'Update Now';
}

// Path: recordItems
class TranslationsRecordItemsEn {
  TranslationsRecordItemsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Record Items';
  String get empty => 'No record items';
  String get searchPlaceholder => 'Search';
  String get searchNotAvailable => 'Search feature is coming soon';
  String get errorMessage => 'An error occurred';
  String get retry => 'Retry';
  String navigateToDetail({required Object title}) =>
      'Navigate to ${title} details';
  String navigateToEdit({required Object title}) => 'Navigate to edit ${title}';
  String get navigateToCreate => 'Navigate to create';
  String deleteConfirm({required Object title}) =>
      'Show delete confirmation for ${title}';
  String get edit => 'Edit';
  String get delete => 'Delete';
}

// Path: payment.header
class TranslationsPaymentHeaderEn {
  TranslationsPaymentHeaderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Unlock More Features';
  String get subtitle => 'Make your daily records even better';
}

// Path: payment.plans
class TranslationsPaymentPlansEn {
  TranslationsPaymentPlansEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsPaymentPlansFreeEn free =
      TranslationsPaymentPlansFreeEn.internal(_root);
  late final TranslationsPaymentPlansStandardEn standard =
      TranslationsPaymentPlansStandardEn.internal(_root);
  late final TranslationsPaymentPlansPremiumEn premium =
      TranslationsPaymentPlansPremiumEn.internal(_root);
}

// Path: payment.price
class TranslationsPaymentPriceEn {
  TranslationsPaymentPriceEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get perMonth => '/month';
}

// Path: payment.buttons
class TranslationsPaymentButtonsEn {
  TranslationsPaymentButtonsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get currentPlan => 'Current Plan';
  String get selectPlan => 'Select This Plan';
  String get recommended => 'Recommended';
}

// Path: payment.plans.free
class TranslationsPaymentPlansFreeEn {
  TranslationsPaymentPlansFreeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Free';
  late final TranslationsPaymentPlansFreeFeaturesEn features =
      TranslationsPaymentPlansFreeFeaturesEn.internal(_root);
}

// Path: payment.plans.standard
class TranslationsPaymentPlansStandardEn {
  TranslationsPaymentPlansStandardEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Standard';
  late final TranslationsPaymentPlansStandardFeaturesEn features =
      TranslationsPaymentPlansStandardFeaturesEn.internal(_root);
}

// Path: payment.plans.premium
class TranslationsPaymentPlansPremiumEn {
  TranslationsPaymentPlansPremiumEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get name => 'Premium';
  late final TranslationsPaymentPlansPremiumFeaturesEn features =
      TranslationsPaymentPlansPremiumFeaturesEn.internal(_root);
}

// Path: payment.plans.free.features
class TranslationsPaymentPlansFreeFeaturesEn {
  TranslationsPaymentPlansFreeFeaturesEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get items => 'Record items: Up to 3';
  String get basicRecording => 'Basic recording features';
  String get simpleStats => 'Simple statistics';
}

// Path: payment.plans.standard.features
class TranslationsPaymentPlansStandardFeaturesEn {
  TranslationsPaymentPlansStandardFeaturesEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get items => 'Record items: Unlimited';
  String get detailedStats => 'Detailed stats & graphs';
  String get dataExport => 'Data export';
  String get reminder => 'Reminder features';
}

// Path: payment.plans.premium.features
class TranslationsPaymentPlansPremiumFeaturesEn {
  TranslationsPaymentPlansPremiumFeaturesEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get allStandard => 'All Standard features';
  String get aiAnalysis => 'AI analysis & advice';
  String get teamShare => 'Team sharing';
  String get prioritySupport => 'Priority support';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
  dynamic _flatMapFunction(String path) {
    switch (path) {
      case 'app.name':
        return 'YattaDay';
      case 'common.retry':
        return 'Retry';
      case 'common.ok':
        return 'OK';
      case 'common.cancel':
        return 'Cancel';
      case 'common.save':
        return 'Save';
      case 'common.edit':
        return 'Edit';
      case 'common.delete':
        return 'Delete';
      case 'common.add':
        return 'Add';
      case 'common.create':
        return 'Create';
      case 'error.unexpected':
        return 'An Unexpected Error has occurred';
      case 'login.title':
        return 'Login';
      case 'login.googleSignIn':
        return 'Sign in with Google';
      case 'login.appleSignIn':
        return 'Sign in with Apple';
      case 'login.anonymousSignIn':
        return 'Continue as Guest';
      case 'settings.title':
        return 'Settings';
      case 'settings.account':
        return 'Account';
      case 'settings.payment':
        return 'Subscription';
      case 'settings.contact':
        return 'Contact Us';
      case 'settings.planManagement':
        return 'Plan Management';
      case 'settings.currentPlan':
        return 'Current Plan';
      case 'settings.free':
        return 'Free';
      case 'settings.profileEdit':
        return 'Edit Profile';
      case 'settings.appSettings':
        return 'App Settings';
      case 'settings.notifications':
        return 'Notifications';
      case 'settings.notificationsDesc':
        return 'Customize reminder notifications';
      case 'settings.theme':
        return 'Theme';
      case 'settings.lightMode':
        return 'Light Mode';
      case 'settings.language':
        return 'Language';
      case 'settings.japanese':
        return 'Japanese';
      case 'settings.support':
        return 'Support';
      case 'settings.help':
        return 'Help';
      case 'settings.contactUs':
        return 'Contact Us';
      case 'settings.terms':
        return 'Terms of Service';
      case 'settings.privacy':
        return 'Privacy Policy';
      case 'settings.logout':
        return 'Logout';
      case 'settings.userName':
        return 'Taro Tanaka';
      case 'settings.userEmail':
        return 'tanaka@example.com';
      case 'payment.title':
        return 'Subscription';
      case 'payment.description':
        return 'Upgrade to premium for more features';
      case 'payment.selectPlan':
        return 'Select Plan';
      case 'payment.header.title':
        return 'Unlock More Features';
      case 'payment.header.subtitle':
        return 'Make your daily records even better';
      case 'payment.currentPlan':
        return ({required Object plan}) => 'Current Plan: ${plan}';
      case 'payment.plans.free.name':
        return 'Free';
      case 'payment.plans.free.features.items':
        return 'Record items: Up to 3';
      case 'payment.plans.free.features.basicRecording':
        return 'Basic recording features';
      case 'payment.plans.free.features.simpleStats':
        return 'Simple statistics';
      case 'payment.plans.standard.name':
        return 'Standard';
      case 'payment.plans.standard.features.items':
        return 'Record items: Unlimited';
      case 'payment.plans.standard.features.detailedStats':
        return 'Detailed stats & graphs';
      case 'payment.plans.standard.features.dataExport':
        return 'Data export';
      case 'payment.plans.standard.features.reminder':
        return 'Reminder features';
      case 'payment.plans.premium.name':
        return 'Premium';
      case 'payment.plans.premium.features.allStandard':
        return 'All Standard features';
      case 'payment.plans.premium.features.aiAnalysis':
        return 'AI analysis & advice';
      case 'payment.plans.premium.features.teamShare':
        return 'Team sharing';
      case 'payment.plans.premium.features.prioritySupport':
        return 'Priority support';
      case 'payment.price.perMonth':
        return '/month';
      case 'payment.buttons.currentPlan':
        return 'Current Plan';
      case 'payment.buttons.selectPlan':
        return 'Select This Plan';
      case 'payment.buttons.recommended':
        return 'Recommended';
      case 'forceUpdate.title':
        return 'Please Update';
      case 'forceUpdate.desc':
        return 'A new version of the app is available. Please update from the store.';
      case 'forceUpdate.label':
        return 'Update Now';
      case 'recordItems.title':
        return 'Record Items';
      case 'recordItems.empty':
        return 'No record items';
      case 'recordItems.searchPlaceholder':
        return 'Search';
      case 'recordItems.searchNotAvailable':
        return 'Search feature is coming soon';
      case 'recordItems.errorMessage':
        return 'An error occurred';
      case 'recordItems.retry':
        return 'Retry';
      case 'recordItems.navigateToDetail':
        return ({required Object title}) => 'Navigate to ${title} details';
      case 'recordItems.navigateToEdit':
        return ({required Object title}) => 'Navigate to edit ${title}';
      case 'recordItems.navigateToCreate':
        return 'Navigate to create';
      case 'recordItems.deleteConfirm':
        return ({required Object title}) =>
            'Show delete confirmation for ${title}';
      case 'recordItems.edit':
        return 'Edit';
      case 'recordItems.delete':
        return 'Delete';
      default:
        return null;
    }
  }
}
