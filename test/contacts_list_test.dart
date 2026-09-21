import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mcash/core/widgets/contacts_list.dart';

void main() {
  group('cleanPhoneNumber', () {
    test('cleans Bangladeshi numbers with +880 prefix', () {
      expect(cleanPhoneNumber('+8801712345678'), equals('01712345678'));
      expect(cleanPhoneNumber('+880 1812-345678'), equals('01812345678'));
    });

    test('cleans Bangladeshi numbers with 880 prefix', () {
      expect(cleanPhoneNumber('8801712345678'), equals('01712345678'));
    });

    test('cleans formatted numbers with spaces and dashes', () {
      expect(cleanPhoneNumber('01712-345678'), equals('01712345678'));
      expect(cleanPhoneNumber('01912 345 679'), equals('01912345679'));
    });
  });

  group('ContactsList Widget', () {
    testWidgets('renders contacts and triggers onContactSelected on tap',
        (WidgetTester tester) async {
      String? selectedNumber;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactsList(
                onContactSelected: (number) {
                  selectedNumber = number;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      // Verify Mom contact exists in default/fallback contacts
      expect(find.text('Mom'), findsOneWidget);
      expect(find.text('01712345678'), findsOneWidget);

      // Tap Mom
      await tester.tap(find.text('Mom'));
      await tester.pump();

      expect(selectedNumber, equals('01712345678'));
    });

    testWidgets('filters contacts when query is entered in search',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactsList(
                onContactSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.widgetWithText(ListTile, 'Mom'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Dad'), findsOneWidget);

      // Search for 'Dad'
      await tester.enterText(find.byType(TextField), 'Dad');
      await tester.pump();

      expect(find.widgetWithText(ListTile, 'Dad'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Mom'), findsNothing);
    });
  });
}
