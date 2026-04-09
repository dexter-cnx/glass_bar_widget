import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glass_bar/glass_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Bar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const DynamicPanelScreen(),
    );
  }
}

class DynamicPanelScreen extends StatefulWidget {
  const DynamicPanelScreen({super.key});

  @override
  State<DynamicPanelScreen> createState() => _DynamicPanelScreenState();
}

class _DynamicPanelScreenState extends State<DynamicPanelScreen> {
  int? _hIndex;
  int? _vIndex;

  late final List<GlassBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = <GlassBarItem>[
      GlassBarItem(
        iconData: Icons.apps_rounded,
        labelText: 'Apps',
        tooltip: 'Apps',
        panelContent: _buildPanelContent(
          'Popular Apps',
          <String>['Figma', 'Notion', 'Spotify', 'Linear'],
        ),
      ),
      GlassBarItem(
        iconData: Icons.widgets_rounded,
        labelText: 'Components',
        tooltip: 'Components',
        panelContent: _buildPanelContent(
          'UI Components',
          <String>[
            'Glass Card',
            'Neumorphic Button',
            'Floating Action',
            'Animated List'
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.note_alt_rounded,
        labelText: 'Notes',
        tooltip: 'Notes',
        panelContent: _buildPanelContent(
          'Quick Notes',
          <String>['Meetings', 'Idea #42', 'Shopping List', 'Roadmap'],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
          ),
          // Main Content Layer
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 40, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Glass Bar Demo',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Flexible GlassBar supporting orientations and theming.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) => _buildCard(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 100,
            bottom: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GlassBar(
                orientation: Axis.vertical,
                selectedIndex: _vIndex,
                items: _navItems,
                onTabChanged: (index) {
                  setState(() => _vIndex = index);
                },
                maxExtent: 500,
              ),
            ),
          ),
          Positioned(
            left: 100,
            right: 20,
            bottom: 24,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GlassBar(
                orientation: Axis.horizontal,
                selectedIndex: _hIndex,
                items: _navItems,
                onTabChanged: (index) {
                  setState(() => _hIndex = index);
                },
                iconAfterLabel: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelContent(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(int index) {
    final colors = [
      Colors.purpleAccent,
      Colors.cyanAccent,
      Colors.amberAccent,
      Colors.greenAccent,
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.3),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Icon(
          Icons.star_rounded,
          size: 40,
          color: colors[index % 4].withValues(alpha: 0.8),
        ),
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOut);
  }
}
