# Memory Lovers Templates

- applicationId: com.memorylovers.yattaday
- appName: Yatta Day
- flavor: dev/stag/prod
- account: <team.yatta.day@gmail.com>
- firebase project
  - prod: yattaday-prod
  - stag: yattaday-stag

## ルーティング

- `/` ... ログイン画面
- `/home` ... ホーム画面(BottomNav)
- `/settings` ... 設定画面(BottomNav)
- `/settings/payment` ... 購入画面

## Documents

各種ドキュメントは以下の場所に配置

- [要件定義](/_docs/01_requirements.md)
- [システムアーキテクチャ/利用技術](_docs/02_system_architecture.md)
- [デザインコンセプト](_docs/03_designs.md)
- [機能一覧](_docs/04_features.md)
- [画面一覧](_docs/05_screens.md)
- [データモデル](_docs/06_data_models.md)
- [コーデングスタイル(Flutter)](_docs/10_cording_style_flutter.md)

## For Flutter

### Setup for Development Evntironment

初回のみ、実施
fvm/melos/flutterfire_cilなどインストールを実行

```shell
make
```

## License

[MIT License](/LICENSE) ©[Memory Lovers, LLC](https://memory-lovers.com)
