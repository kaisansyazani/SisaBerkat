import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_chatbot_app/main.dart';

void main() {
  testWidgets('Chat input and send button test', (WidgetTester tester) async {
    // Build the Chatbot app
    await tester.pumpWidget(MyApp());

    // Verify the input field is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify the send button is present
    expect(find.byIcon(Icons.send), findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(find.byType(TextField), 'Hello AI');

    // Tap the send button
    await tester.tap(find.byIcon(Icons.send));

    // Rebuild the widget after the state has changed
    await tester.pump();

    // Since this is a live API call, we don't check the response content here
    // But we verify that the user's message appears in the list
    expect(find.text('Hello AI'), findsOneWidget);
  });
}
