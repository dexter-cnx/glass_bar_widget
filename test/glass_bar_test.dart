import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_bar/glass_bar.dart';

void main() {
  List<GlassBarItem> buildItems() {
    return const <GlassBarItem>[
      GlassBarItem(
        iconData: Icons.home,
        labelText: 'Home',
        panelContent: Text('Home Panel'),
      ),
      GlassBarItem(
        iconData: Icons.settings,
        labelText: 'Settings',
        panelContent: Text('Settings Panel'),
      ),
    ];
  }

  testWidgets('renders items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassBar(items: buildItems()),
        ),
      ),
    );

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('uncontrolled mode selects and deselects', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassBar(items: buildItems()),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Home Panel'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.text('Home Panel'), findsNothing);
  });

  testWidgets('controlled mode reports changes', (tester) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: GlassBar(
                items: buildItems(),
                selectedIndex: selected,
                onTabChanged: (value) {
                  setState(() => selected = value);
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings Panel'), findsOneWidget);
  });

  testWidgets('auto hide closes panel after duration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassBar(
            items: buildItems(),
            panelAutoHideDuration: const Duration(milliseconds: 10),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.home));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Home Panel'), findsNothing);
  });
}
