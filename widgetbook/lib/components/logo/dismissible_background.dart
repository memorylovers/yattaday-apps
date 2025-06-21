import 'package:flutter/material.dart';
import 'package:common_widget/common_widget.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: DismissibleBackground,
  path: 'components/logo',
)
Widget defaultDismissibleBackground(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 350,
        height: 100,
        child: DismissibleBackground(
          child: Icon(Icons.delete, color: Colors.white, size: 32),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Colors',
  type: DismissibleBackground,
  path: 'components/logo',
)
Widget customColorsDismissibleBackground(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              backgroundColor: Colors.red,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text('削除', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              backgroundColor: Colors.green,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.archive, color: Colors.white),
                  SizedBox(width: 8),
                  Text('アーカイブ', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              backgroundColor: Colors.blue,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag, color: Colors.white),
                  SizedBox(width: 8),
                  Text('フラグ', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Different Alignments',
  type: DismissibleBackground,
  path: 'components/logo',
)
Widget differentAlignmentsDismissibleBackground(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              alignment: Alignment.centerLeft,
              child: Text(
                '左寄せ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              alignment: Alignment.center,
              child: Text(
                '中央',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              alignment: Alignment.centerRight,
              child: Text(
                '右寄せ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Border Radius',
  type: DismissibleBackground,
  path: 'components/logo',
)
Widget borderRadiusDismissibleBackground(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              borderRadius: BorderRadius.circular(8),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              borderRadius: BorderRadius.circular(16),
              backgroundColor: Colors.orange,
              child: Icon(Icons.warning, color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            height: 80,
            child: DismissibleBackground(
              borderRadius: BorderRadius.circular(40),
              backgroundColor: Colors.purple,
              child: Icon(Icons.star, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Interactive Example',
  type: DismissibleBackground,
  path: 'components/logo',
)
Widget interactiveDismissibleBackground(BuildContext context) {
  final colorOptions = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Orange': Colors.orange,
    'Purple': Colors.purple,
  };

  final selectedColor = context.knobs.list(
    label: 'Background Color',
    options: colorOptions.keys.toList(),
    initialOption: 'Red',
  );

  final alignmentOptions = {
    'Left': Alignment.centerLeft,
    'Center': Alignment.center,
    'Right': Alignment.centerRight,
  };

  final selectedAlignment = context.knobs.list(
    label: 'Alignment',
    options: alignmentOptions.keys.toList(),
    initialOption: 'Right',
  );

  final borderRadius = context.knobs.double.slider(
    label: 'Border Radius',
    initialValue: 8,
    min: 0,
    max: 40,
  );

  final margin = context.knobs.double.slider(
    label: 'Margin',
    initialValue: 0,
    min: 0,
    max: 32,
  );

  return Container(
    color: Colors.grey[200],
    child: Center(
      child: SizedBox(
        width: 350,
        height: 100,
        child: DismissibleBackground(
          backgroundColor: colorOptions[selectedColor],
          alignment: alignmentOptions[selectedAlignment]!,
          borderRadius: BorderRadius.circular(borderRadius),
          margin: EdgeInsets.all(margin),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'スワイプで削除',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'List Item Example',
  type: DismissibleBackground,
  path: 'components/logo',
)
Widget listItemDismissibleBackground(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            DismissibleBackground(
              borderRadius: BorderRadius.circular(12),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                  SizedBox(width: 16),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('A'),
                ),
                title: Text('タスクアイテム'),
                subtitle: Text('スワイプして削除'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
