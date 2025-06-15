import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/record_item.dart';
import '../widgets/record_item_form.dart';

/// 記録項目編集ページ
class RecordItemsEditPage extends ConsumerWidget {
  const RecordItemsEditPage({
    super.key,
    required this.userId,
    required this.recordItem,
  });

  final String userId;
  final RecordItem recordItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('記録項目編集'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF5DD3DC),
              const Color(0xFF7EDBB7),
              const Color(0xFFF5D563),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            color: Colors.white,
            child: RecordItemForm(
              userId: userId,
              initialItem: recordItem,
              onSuccess: () {
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
