import 'package:flutter_test/flutter_test.dart';

import 'package:getpocket/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('App widget test', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
  });
}
