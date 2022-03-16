import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_window_title_issue/main.dart' as app;

void main() {
  testWidgets('window title', (tester) async {
    app.main();
    // await tester.pumpAndSettle();

    for (var i = 0; i < 24; ++i) {
      await Future.delayed(const Duration(seconds: 1), tester.pump);
    }
  });
}
