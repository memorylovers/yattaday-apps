import 'package:flutter/material.dart';
import 'package:myapp/components/scaffold/gradient_scaffold.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// GradientScaffoldのWidgetbook用ストーリー
@widgetbook.UseCase(
  name: 'Default',
  type: GradientScaffold,
  path: 'components/scaffold',
)
Widget defaultGradientScaffold(BuildContext context) {
  return const GradientScaffold(
    body: Center(
      child: Text('デフォルトのGradientScaffold', style: TextStyle(fontSize: 20)),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Title',
  type: GradientScaffold,
  path: 'components/scaffold',
)
Widget withTitleGradientScaffold(BuildContext context) {
  return GradientScaffold(
    title: context.knobs.string(label: 'Title', initialValue: 'ページタイトル'),
    body: const Center(
      child: Text('タイトル付きGradientScaffold', style: TextStyle(fontSize: 20)),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Actions',
  type: GradientScaffold,
  path: 'components/scaffold',
)
Widget withActionsGradientScaffold(BuildContext context) {
  return GradientScaffold(
    title: 'アクション付き',
    actions: [
      IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
      IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
    ],
    body: const Center(
      child: Text('アクションボタン付きGradientScaffold', style: TextStyle(fontSize: 20)),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With FAB',
  type: GradientScaffold,
  path: 'components/scaffold',
)
Widget withFABGradientScaffold(BuildContext context) {
  return GradientScaffold(
    title: 'FAB付き',
    body: const Center(
      child: Text(
        'FloatingActionButton付きGradientScaffold',
        style: TextStyle(fontSize: 20),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color(0xFF5DD3DC),
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With White Container',
  type: GradientScaffold,
  path: 'components/scaffold',
)
Widget withWhiteContainerGradientScaffold(BuildContext context) {
  return GradientScaffold(
    title: '白背景コンテナ',
    useWhiteContainer: context.knobs.boolean(
      label: 'Use White Container',
      initialValue: true,
    ),
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text('アイテム ${index + 1}'),
            subtitle: const Text('白背景コンテナ内のコンテンツ'),
            leading: CircleAvatar(child: Text('${index + 1}')),
          ),
        );
      },
    ),
  );
}

@widgetbook.UseCase(
  name: 'Complex Example',
  type: GradientScaffold,
  path: 'components/scaffold',
)
Widget complexExampleGradientScaffold(BuildContext context) {
  return GradientScaffold(
    title: '記録項目一覧',
    showBackButton: true,
    actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
    useWhiteContainer: true,
    bottomPadding: 80,
    bottomSafeArea: context.knobs.boolean(
      label: 'Bottom Safe Area',
      initialValue: false,
    ),
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('記録項目 ${index + 1}'),
            subtitle: Text('${index * 10 + 5} 回完了'),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {},
            ),
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: const Color(0xFF5DD3DC),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('新規作成', style: TextStyle(color: Colors.white)),
    ),
  );
}
