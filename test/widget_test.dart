import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/main.dart';
import 'package:currency_converter/splash_screen.dart';
import 'package:currency_converter/home_screen.dart';

void main() {
  testWidgets('Splash screen navigates to HomeScreen with segments', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that SplashScreen is displayed initially
    expect(find.byType(SplashScreen), findsOneWidget);

    // Fast-forward animation and timer (3.5s + transition)
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify HomeScreen is loaded
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify the 3 requested segments are present
    expect(find.text('keep note'), findsWidgets);
    expect(find.text('expense track'), findsWidgets);
    expect(find.text('currency convert'), findsWidgets);
  });
}
