import 'package:flutter_test/flutter_test.dart';

import 'package:cupertino_context_menu_demo/main.dart';

void main() {
  testWidgets('App boots and shows Chats screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CupertinoContextMenuDemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Props'), findsOneWidget);
  });
}
