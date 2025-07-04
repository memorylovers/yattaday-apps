import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/record_items/1_models/record_item.dart';

void main() {
  group('RecordItem', () {
    final testDate = DateTime(2024, 1, 1);
    final updatedDate = DateTime(2024, 1, 2);

    test('正しく作成できる', () {
      final item = RecordItem(
        id: 'test-id',
        userId: 'test-user-id',
        title: 'テスト項目',
        description: 'テスト用の説明',
        icon: '📝',
        unit: '回',
        sortOrder: 0,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(item.id, 'test-id');
      expect(item.userId, 'test-user-id');
      expect(item.title, 'テスト項目');
      expect(item.description, 'テスト用の説明');
      expect(item.icon, '📝');
      expect(item.unit, '回');
      expect(item.sortOrder, 0);
      expect(item.createdAt, testDate);
      expect(item.updatedAt, testDate);
    });

    test('descriptionとunitはnull可能', () {
      final item = RecordItem(
        id: 'test-id',
        userId: 'test-user-id',
        title: 'テスト項目',
        icon: '📝',
        sortOrder: 0,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(item.description, isNull);
      expect(item.unit, isNull);
    });

    group('fromJson/toJson', () {
      test('JSONから正しく変換できる', () {
        final json = {
          'id': 'test-id',
          'userId': 'test-user-id',
          'title': 'テスト項目',
          'description': 'テスト用の説明',
          'icon': '📝',
          'unit': '回',
          'sortOrder': 0,
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-02T00:00:00.000',
        };

        final item = RecordItem.fromJson(json);

        expect(item.id, 'test-id');
        expect(item.userId, 'test-user-id');
        expect(item.title, 'テスト項目');
        expect(item.description, 'テスト用の説明');
        expect(item.icon, '📝');
        expect(item.unit, '回');
        expect(item.sortOrder, 0);
        expect(item.createdAt, DateTime.parse('2024-01-01T00:00:00.000'));
        expect(item.updatedAt, DateTime.parse('2024-01-02T00:00:00.000'));
      });

      test('JSONに正しく変換できる', () {
        final item = RecordItem(
          id: 'test-id',
          userId: 'test-user-id',
          title: 'テスト項目',
          description: 'テスト用の説明',
          icon: '📝',
          unit: '回',
          sortOrder: 0,
          createdAt: testDate,
          updatedAt: updatedDate,
        );

        final json = item.toJson();

        expect(json['id'], 'test-id');
        expect(json['userId'], 'test-user-id');
        expect(json['title'], 'テスト項目');
        expect(json['description'], 'テスト用の説明');
        expect(json['icon'], '📝');
        expect(json['unit'], '回');
        expect(json['sortOrder'], 0);
        expect(json['createdAt'], '2024-01-01T00:00:00.000');
        expect(json['updatedAt'], '2024-01-02T00:00:00.000');
      });

      test('null値を含むJSONから正しく変換できる', () {
        final json = {
          'id': 'test-id',
          'userId': 'test-user-id',
          'title': 'テスト項目',
          // descriptionとunitは未定義
          'icon': '📝',
          'sortOrder': 0,
          'createdAt': '2024-01-01T00:00:00.000',
          'updatedAt': '2024-01-01T00:00:00.000',
        };

        final item = RecordItem.fromJson(json);

        expect(item.id, 'test-id');
        expect(item.userId, 'test-user-id');
        expect(item.title, 'テスト項目');
        expect(item.description, isNull);
        expect(item.icon, '📝');
        expect(item.unit, isNull);
        expect(item.sortOrder, 0);
      });
    });

    group('copyWith', () {
      test('一部のフィールドを更新できる', () {
        final original = RecordItem(
          id: 'test-id',
          userId: 'test-user-id',
          title: '元のタイトル',
          description: '元の説明',
          icon: '📝',
          unit: '回',
          sortOrder: 0,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(
          title: '更新後のタイトル',
          unit: '分',
          updatedAt: updatedDate,
        );

        expect(updated.id, 'test-id');
        expect(updated.userId, 'test-user-id');
        expect(updated.title, '更新後のタイトル');
        expect(updated.description, '元の説明');
        expect(updated.icon, '📝');
        expect(updated.unit, '分');
        expect(updated.sortOrder, 0);
        expect(updated.createdAt, testDate);
        expect(updated.updatedAt, updatedDate);
      });

      test('nullに更新できる', () {
        final original = RecordItem(
          id: 'test-id',
          userId: 'test-user-id',
          title: 'テスト項目',
          description: '説明あり',
          icon: '📝',
          unit: '回',
          sortOrder: 0,
          createdAt: testDate,
          updatedAt: testDate,
        );

        final updated = original.copyWith(description: null, unit: null);

        expect(updated.description, isNull);
        expect(updated.unit, isNull);
      });
    });

    group('sortOrder', () {
      test('sortOrderで並び替えできる', () {
        final items = [
          RecordItem(
            id: 'id-1',
            userId: 'user-id',
            title: '項目1',
            icon: '1️⃣',
            sortOrder: 2,
            createdAt: testDate,
            updatedAt: testDate,
          ),
          RecordItem(
            id: 'id-2',
            userId: 'user-id',
            title: '項目2',
            icon: '2️⃣',
            sortOrder: 0,
            createdAt: testDate,
            updatedAt: testDate,
          ),
          RecordItem(
            id: 'id-3',
            userId: 'user-id',
            title: '項目3',
            icon: '3️⃣',
            sortOrder: 1,
            createdAt: testDate,
            updatedAt: testDate,
          ),
        ];

        items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        expect(items[0].title, '項目2');
        expect(items[1].title, '項目3');
        expect(items[2].title, '項目1');
      });
    });

    group('アイコンの処理', () {
      test('絵文字アイコンを設定できる', () {
        final item = RecordItem(
          id: 'test-id',
          userId: 'test-user-id',
          title: 'テスト項目',
          icon: '🎯',
          sortOrder: 0,
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(item.icon, '🎯');
      });

      test('複数文字の絵文字も設定できる', () {
        final item = RecordItem(
          id: 'test-id',
          userId: 'test-user-id',
          title: 'テスト項目',
          icon: '👨‍💻',
          sortOrder: 0,
          createdAt: testDate,
          updatedAt: testDate,
        );

        expect(item.icon, '👨‍💻');
      });
    });
  });
}
