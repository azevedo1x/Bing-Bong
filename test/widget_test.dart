import 'package:flutter_test/flutter_test.dart';
import 'package:bingbong/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BingBongApp());
    expect(find.byType(BingBongApp), findsOneWidget);
  });
}
