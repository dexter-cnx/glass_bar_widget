import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_bar/glass_bar.dart';

void main() {
  List<GlassBarItem> buildItems() {
    return const <GlassBarItem>[
      GlassBarItem(
        iconData: Icons.home,
        activeIconData: Icons.home_filled,
        labelText: 'Home',
        panelContent: Text('Home Panel'),
        badgeText: '3',
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

    expect(find.byIcon(Icons.home_filled), findsOneWidget);
    await tester.tap(find.byIcon(Icons.home_filled));
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

  testWidgets('supports active icon and badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassBar(
            items: const <GlassBarItem>[
              GlassBarItem(
                iconData: Icons.home_outlined,
                activeIcon: Icon(Icons.home),
                labelText: 'Home',
                badgeText: '3',
                panelContent: Text('Home Panel'),
              ),
              GlassBarItem(
                iconData: Icons.settings_outlined,
                activeIcon: Icon(Icons.settings),
                labelText: 'Settings',
                panelContent: Text('Settings Panel'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('letIndexChange can block selection changes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassBar(
            items: buildItems(),
            letIndexChange: (current, next) => next != 1,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings Panel'), findsNothing);
  });

  testWidgets('showLabelMode.always shows label even when not selected',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassBar(
            items: buildItems(),
            showLabelMode: ShowLabelMode.always,
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
