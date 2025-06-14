///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsJa extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAppJa app = _TranslationsAppJa._(_root);
	@override late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
	@override late final _TranslationsErrorJa error = _TranslationsErrorJa._(_root);
	@override late final _TranslationsLoginJa login = _TranslationsLoginJa._(_root);
	@override late final _TranslationsSettingsJa settings = _TranslationsSettingsJa._(_root);
	@override late final _TranslationsPaymentJa payment = _TranslationsPaymentJa._(_root);
	@override late final _TranslationsForceUpdateJa forceUpdate = _TranslationsForceUpdateJa._(_root);
}

// Path: app
class _TranslationsAppJa extends TranslationsAppEn {
	_TranslationsAppJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => 'YattaDay';
}

// Path: common
class _TranslationsCommonJa extends TranslationsCommonEn {
	_TranslationsCommonJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get retry => 'Retry';
	@override String get ok => 'OK';
	@override String get cancel => 'Cancel';
	@override String get save => 'Save';
	@override String get edit => 'Edit';
	@override String get delete => 'Delete';
	@override String get add => 'Add';
	@override String get create => 'Create';
}

// Path: error
class _TranslationsErrorJa extends TranslationsErrorEn {
	_TranslationsErrorJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'エラーが発生しました';
}

// Path: login
class _TranslationsLoginJa extends TranslationsLoginEn {
	_TranslationsLoginJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログイン';
	@override String get googleSignIn => 'Googleでログイン';
	@override String get appleSignIn => 'Appleでログイン';
	@override String get anonymousSignIn => 'ログインなしではじめる';
}

// Path: settings
class _TranslationsSettingsJa extends TranslationsSettingsEn {
	_TranslationsSettingsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override String get account => 'アカウント';
	@override String get payment => 'Subscription';
	@override String get contact => 'Contact Us';
	@override String get planManagement => 'プラン管理';
	@override String get currentPlan => '現在のプラン';
	@override String get free => 'フリー';
	@override String get profileEdit => 'プロフィール編集';
	@override String get appSettings => 'アプリ設定';
	@override String get notifications => '通知設定';
	@override String get notificationsDesc => 'リマインダー通知などカスタマイズ';
	@override String get theme => 'テーマ';
	@override String get lightMode => 'ライトモード';
	@override String get language => '言語';
	@override String get japanese => '日本語';
	@override String get support => 'サポート';
	@override String get help => 'ヘルプ';
	@override String get contactUs => 'お問い合わせ';
	@override String get terms => '利用規約';
	@override String get privacy => 'プライバシーポリシー';
	@override String get logout => 'ログアウト';
	@override String get userName => '田中 太郎';
	@override String get userEmail => 'tanaka@example.com';
}

// Path: payment
class _TranslationsPaymentJa extends TranslationsPaymentEn {
	_TranslationsPaymentJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'プレミアムプラン';
	@override String get description => 'プレミアムでより多くの機能を開放しよう';
	@override String get selectPlan => 'プラン選択';
	@override late final _TranslationsPaymentHeaderJa header = _TranslationsPaymentHeaderJa._(_root);
	@override String currentPlan({required Object plan}) => '現在のプラン: ${plan}';
	@override late final _TranslationsPaymentPlansJa plans = _TranslationsPaymentPlansJa._(_root);
	@override late final _TranslationsPaymentPriceJa price = _TranslationsPaymentPriceJa._(_root);
	@override late final _TranslationsPaymentButtonsJa buttons = _TranslationsPaymentButtonsJa._(_root);
}

// Path: forceUpdate
class _TranslationsForceUpdateJa extends TranslationsForceUpdateEn {
	_TranslationsForceUpdateJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '更新のお知らせ';
	@override String get desc => '新しいバージョンのアプリが利用可能です。ストアより更新ください';
	@override String get label => '今すぐ更新';
}

// Path: payment.header
class _TranslationsPaymentHeaderJa extends TranslationsPaymentHeaderEn {
	_TranslationsPaymentHeaderJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'より多くの機能を利用して';
	@override String get subtitle => '毎日の記録をさらに便利に';
}

// Path: payment.plans
class _TranslationsPaymentPlansJa extends TranslationsPaymentPlansEn {
	_TranslationsPaymentPlansJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsPaymentPlansFreeJa free = _TranslationsPaymentPlansFreeJa._(_root);
	@override late final _TranslationsPaymentPlansStandardJa standard = _TranslationsPaymentPlansStandardJa._(_root);
	@override late final _TranslationsPaymentPlansPremiumJa premium = _TranslationsPaymentPlansPremiumJa._(_root);
}

// Path: payment.price
class _TranslationsPaymentPriceJa extends TranslationsPaymentPriceEn {
	_TranslationsPaymentPriceJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get perMonth => '/月';
}

// Path: payment.buttons
class _TranslationsPaymentButtonsJa extends TranslationsPaymentButtonsEn {
	_TranslationsPaymentButtonsJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get currentPlan => '現在のプラン';
	@override String get selectPlan => 'このプランを選択';
	@override String get recommended => 'おすすめ';
}

// Path: payment.plans.free
class _TranslationsPaymentPlansFreeJa extends TranslationsPaymentPlansFreeEn {
	_TranslationsPaymentPlansFreeJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => 'フリー';
	@override late final _TranslationsPaymentPlansFreeFeaturesJa features = _TranslationsPaymentPlansFreeFeaturesJa._(_root);
}

// Path: payment.plans.standard
class _TranslationsPaymentPlansStandardJa extends TranslationsPaymentPlansStandardEn {
	_TranslationsPaymentPlansStandardJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => 'スタンダード';
	@override late final _TranslationsPaymentPlansStandardFeaturesJa features = _TranslationsPaymentPlansStandardFeaturesJa._(_root);
}

// Path: payment.plans.premium
class _TranslationsPaymentPlansPremiumJa extends TranslationsPaymentPlansPremiumEn {
	_TranslationsPaymentPlansPremiumJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => 'プレミアム';
	@override late final _TranslationsPaymentPlansPremiumFeaturesJa features = _TranslationsPaymentPlansPremiumFeaturesJa._(_root);
}

// Path: payment.plans.free.features
class _TranslationsPaymentPlansFreeFeaturesJa extends TranslationsPaymentPlansFreeFeaturesEn {
	_TranslationsPaymentPlansFreeFeaturesJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get items => '記録項目: 3つまで';
	@override String get basicRecording => '基本的な記録機能';
	@override String get simpleStats => 'シンプルな統計';
}

// Path: payment.plans.standard.features
class _TranslationsPaymentPlansStandardFeaturesJa extends TranslationsPaymentPlansStandardFeaturesEn {
	_TranslationsPaymentPlansStandardFeaturesJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get items => '記録項目: 無制限';
	@override String get detailedStats => '詳細な統計・グラフ';
	@override String get dataExport => 'データエクスポート';
	@override String get reminder => 'リマインダー機能';
}

// Path: payment.plans.premium.features
class _TranslationsPaymentPlansPremiumFeaturesJa extends TranslationsPaymentPlansPremiumFeaturesEn {
	_TranslationsPaymentPlansPremiumFeaturesJa._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get allStandard => 'スタンダードの全機能';
	@override String get aiAnalysis => 'AI分析・アドバイス';
	@override String get teamShare => 'チーム共有機能';
	@override String get prioritySupport => '優先サポート';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.name': return 'YattaDay';
			case 'common.retry': return 'Retry';
			case 'common.ok': return 'OK';
			case 'common.cancel': return 'Cancel';
			case 'common.save': return 'Save';
			case 'common.edit': return 'Edit';
			case 'common.delete': return 'Delete';
			case 'common.add': return 'Add';
			case 'common.create': return 'Create';
			case 'error.unexpected': return 'エラーが発生しました';
			case 'login.title': return 'ログイン';
			case 'login.googleSignIn': return 'Googleでログイン';
			case 'login.appleSignIn': return 'Appleでログイン';
			case 'login.anonymousSignIn': return 'ログインなしではじめる';
			case 'settings.title': return '設定';
			case 'settings.account': return 'アカウント';
			case 'settings.payment': return 'Subscription';
			case 'settings.contact': return 'Contact Us';
			case 'settings.planManagement': return 'プラン管理';
			case 'settings.currentPlan': return '現在のプラン';
			case 'settings.free': return 'フリー';
			case 'settings.profileEdit': return 'プロフィール編集';
			case 'settings.appSettings': return 'アプリ設定';
			case 'settings.notifications': return '通知設定';
			case 'settings.notificationsDesc': return 'リマインダー通知などカスタマイズ';
			case 'settings.theme': return 'テーマ';
			case 'settings.lightMode': return 'ライトモード';
			case 'settings.language': return '言語';
			case 'settings.japanese': return '日本語';
			case 'settings.support': return 'サポート';
			case 'settings.help': return 'ヘルプ';
			case 'settings.contactUs': return 'お問い合わせ';
			case 'settings.terms': return '利用規約';
			case 'settings.privacy': return 'プライバシーポリシー';
			case 'settings.logout': return 'ログアウト';
			case 'settings.userName': return '田中 太郎';
			case 'settings.userEmail': return 'tanaka@example.com';
			case 'payment.title': return 'プレミアムプラン';
			case 'payment.description': return 'プレミアムでより多くの機能を開放しよう';
			case 'payment.selectPlan': return 'プラン選択';
			case 'payment.header.title': return 'より多くの機能を利用して';
			case 'payment.header.subtitle': return '毎日の記録をさらに便利に';
			case 'payment.currentPlan': return ({required Object plan}) => '現在のプラン: ${plan}';
			case 'payment.plans.free.name': return 'フリー';
			case 'payment.plans.free.features.items': return '記録項目: 3つまで';
			case 'payment.plans.free.features.basicRecording': return '基本的な記録機能';
			case 'payment.plans.free.features.simpleStats': return 'シンプルな統計';
			case 'payment.plans.standard.name': return 'スタンダード';
			case 'payment.plans.standard.features.items': return '記録項目: 無制限';
			case 'payment.plans.standard.features.detailedStats': return '詳細な統計・グラフ';
			case 'payment.plans.standard.features.dataExport': return 'データエクスポート';
			case 'payment.plans.standard.features.reminder': return 'リマインダー機能';
			case 'payment.plans.premium.name': return 'プレミアム';
			case 'payment.plans.premium.features.allStandard': return 'スタンダードの全機能';
			case 'payment.plans.premium.features.aiAnalysis': return 'AI分析・アドバイス';
			case 'payment.plans.premium.features.teamShare': return 'チーム共有機能';
			case 'payment.plans.premium.features.prioritySupport': return '優先サポート';
			case 'payment.price.perMonth': return '/月';
			case 'payment.buttons.currentPlan': return '現在のプラン';
			case 'payment.buttons.selectPlan': return 'このプランを選択';
			case 'payment.buttons.recommended': return 'おすすめ';
			case 'forceUpdate.title': return '更新のお知らせ';
			case 'forceUpdate.desc': return '新しいバージョンのアプリが利用可能です。ストアより更新ください';
			case 'forceUpdate.label': return '今すぐ更新';
			default: return null;
		}
	}
}

