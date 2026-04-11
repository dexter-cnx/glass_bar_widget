import 'package:flutter/material.dart';
import 'package:glass_bar/glass_bar.dart';

void main() {
  runApp(const GlassBarShowcaseApp());
}

// ─── App ──────────────────────────────────────────────────────────────────────

class GlassBarShowcaseApp extends StatelessWidget {
  const GlassBarShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Bar Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF070A12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF64B5F6),
          surface: Color(0xFF0F1729),
        ),
      ),
      home: const ShowcaseShell(),
    );
  }
}

// ─── Shell ────────────────────────────────────────────────────────────────────

class ShowcaseShell extends StatefulWidget {
  const ShowcaseShell({super.key});

  @override
  State<ShowcaseShell> createState() => _ShowcaseShellState();
}

class _ShowcaseShellState extends State<ShowcaseShell> {
  int _pageIndex = 0;

  static const List<({String label, IconData icon})> _pages = [
    (label: 'Basic', icon: Icons.phone_android_rounded),
    (label: 'Sidebar', icon: Icons.view_sidebar_rounded),
    (label: 'Compact', icon: Icons.compress_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glass Bar Showcase'),
        titleSpacing: 20,
        backgroundColor: const Color(0xFF070A12),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _PagePills(
                pages: _pages,
                selectedIndex: _pageIndex,
                onChanged: (int i) => setState(() => _pageIndex = i),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          const _AppBackground(),
          Positioned.fill(
            child: SafeArea(
              top: false,
              child: IndexedStack(
                index: _pageIndex,
                children: const <Widget>[
                  BasicPage(),
                  SidebarPage(),
                  CompactPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PagePills extends StatelessWidget {
  const _PagePills({
    required this.pages,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<({String label, IconData icon})> pages;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(pages.length, (int i) {
          final bool selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    pages[i].icon,
                    size: 13,
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    pages[i].label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Shared items ─────────────────────────────────────────────────────────────

List<GlassBarItem> _buildItems() => <GlassBarItem>[
      GlassBarItem(
        iconData: Icons.home_rounded,
        labelText: 'Home',
        panelContent: const _PanelContent(
          title: 'Home',
          items: <String>[
            'Dashboard',
            'Activity feed',
            'Pinned items',
            'Quick actions'
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.explore_rounded,
        labelText: 'Explore',
        panelContent: const _PanelContent(
          title: 'Explore',
          items: <String>[
            'Trending',
            'Categories',
            'Recommended',
            'Collections'
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.notifications_rounded,
        labelText: 'Alerts',
        panelContent: const _PanelContent(
          title: 'Alerts',
          items: <String>[
            '3 unread',
            'Mentions',
            'Team updates',
            'System events'
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.person_rounded,
        labelText: 'Profile',
        panelContent: const _PanelContent(
          title: 'Profile',
          items: <String>['Account', 'Privacy', 'Themes', 'Sign out'],
        ),
      ),
    ];

// ─── Page 1 · Basic ───────────────────────────────────────────────────────────
// Full mobile shell — GlassBar at the bottom, horizontal orientation.
// Features: initialIndex, expandSelectedItem, deselectOnTapWhenSelected,
//           maxExtent, GlassBarThemeData, itemAnimationCurve,
//           panelShowDuration / panelHideDuration, panelAnimationCurve.

class BasicPage extends StatefulWidget {
  const BasicPage({super.key});

  @override
  State<BasicPage> createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  late final List<GlassBarItem> _items;
  int? _selectedIndex = 0;

  static const List<String> _tabLabels = <String>[
    'Home',
    'Explore',
    'Alerts',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _items = _buildItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: _FeatureChips(const <String>[
            'initialIndex: 0',
            'expandSelectedItem: true',
            'deselectOnTapWhenSelected: true',
            'maxExtent: 480',
            'GlassBarThemeData (cyan)',
            'itemAnimationCurve: easeInOut',
            'panelAnimationCurve: easeOutCubic',
          ]),
        ),
        Expanded(
          child: Center(
            child: _PhoneMockup(
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildAppContent()),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: GlassBar(
                      items: _items,
                      orientation: Axis.horizontal,
                      selectedIndex: _selectedIndex,
                      onTabChanged: (int? i) =>
                          setState(() => _selectedIndex = i),
                      maxExtent: 480,
                      expandSelectedItem: true,
                      deselectOnTapWhenSelected: true,
                      itemAnimationDuration: const Duration(milliseconds: 280),
                      itemAnimationCurve: Curves.easeInOut,
                      panelShowDuration: const Duration(milliseconds: 420),
                      panelHideDuration: const Duration(milliseconds: 220),
                      panelAnimationCurve: Curves.easeOutCubic,
                      theme: const GlassBarThemeData(
                        backgroundColor: Color(0x1F88D8FF),
                        selectedItemBackgroundColor: Color(0x33FFFFFF),
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Color(0xBFFFFFFF),
                        blur: 22,
                        borderRadius: 30,
                        borderSide: BorderSide(
                          color: Color(0x5900E5FF),
                          width: 1.4,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                        panelBackgroundColor: Color(0x1E89C2FF),
                        panelBlur: 40,
                        panelBorderRadius: 20,
                        panelBorderSide: BorderSide(color: Color(0x4DFFFFFF)),
                        barPadding: EdgeInsets.all(8),
                        panelPadding: EdgeInsets.all(16),
                        boxShadows: <BoxShadow>[
                          BoxShadow(
                            color: Color(0x59000000),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppContent() {
    final int? sel = _selectedIndex;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sel != null ? _tabLabels[sel] : 'Tap a tab',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
              children: List<Widget>.generate(
                4,
                (int i) => _ContentCard(index: i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 2 · Sidebar ─────────────────────────────────────────────────────────
// Tablet / desktop split — GlassBar on the left as a vertical side rail.
// Features: orientation: vertical, rotateLabelInVertical, iconAfterLabel,
//           maxExtent (height), verticalPanelMaxWidth, GlassBarThemeData (purple).

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  late final List<GlassBarItem> _items;
  int? _selectedIndex;
  bool _rotateLabelInVertical = true;
  bool _iconAfterLabel = false;

  static const List<String> _tabLabels = <String>[
    'Home',
    'Explore',
    'Alerts',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _items = _buildItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            children: <Widget>[
              Flexible(
                child: _FeatureChips(const <String>[
                  'orientation: vertical',
                  'maxExtent: 320',
                  'verticalPanelMaxWidth: 220',
                ]),
              ),
              const SizedBox(width: 10),
              _ToggleChip(
                label: 'Rotate label',
                value: _rotateLabelInVertical,
                onChanged: (bool v) =>
                    setState(() => _rotateLabelInVertical = v),
              ),
              const SizedBox(width: 6),
              _ToggleChip(
                label: 'Icon after label',
                value: _iconAfterLabel,
                onChanged: (bool v) => setState(() => _iconAfterLabel = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: _DesktopFrame(
              sidebar: Padding(
                padding: const EdgeInsets.all(14),
                child: GlassBar(
                  items: _items,
                  orientation: Axis.vertical,
                  selectedIndex: _selectedIndex,
                  onTabChanged: (int? i) => setState(() => _selectedIndex = i),
                  maxExtent: 320,
                  verticalPanelMaxWidth: 220,
                  rotateLabelInVertical: _rotateLabelInVertical,
                  iconAfterLabel: _iconAfterLabel,
                  expandSelectedItem: true,
                  deselectOnTapWhenSelected: true,
                  panelShowDuration: const Duration(milliseconds: 380),
                  panelHideDuration: const Duration(milliseconds: 200),
                  panelAutoHideDuration: const Duration(milliseconds: 1100),
                  panelAnimationCurve: Curves.easeOutCubic,
                  itemAnimationDuration: const Duration(milliseconds: 260),
                  itemAnimationCurve: Curves.easeInOut,
                  theme: const GlassBarThemeData(
                    backgroundColor: Color(0x1AA855F7),
                    selectedItemBackgroundColor: Color(0x33E9D5FF),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Color(0xBFFFFFFF),
                    blur: 20,
                    borderRadius: 24,
                    borderSide: BorderSide(
                      color: Color(0x55A855F7),
                      width: 1.2,
                    ),
                    labelStyle: TextStyle(fontWeight: FontWeight.w600),
                    panelBackgroundColor: Color(0x1AC4B5FD),
                    panelBlur: 40,
                    panelBorderRadius: 20,
                    panelBorderSide: BorderSide(color: Color(0x33FFFFFF)),
                    barPadding: EdgeInsets.all(8),
                    panelPadding: EdgeInsets.all(16),
                    boxShadows: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 20,
                        offset: Offset(10, 0),
                      ),
                    ],
                  ),
                ),
              ),
              content: _buildAppContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppContent() {
    final int? sel = _selectedIndex;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sel != null ? _tabLabels[sel] : 'Select a section',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: List<Widget>.generate(
                6,
                (int i) => _ContentCard(index: i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 3 · Compact ─────────────────────────────────────────────────────────
// Dense layout — fully controlled selectedIndex + panelAutoHideDuration.
// Features: selectedIndex (controlled), panelAutoHideDuration,
//           expandSelectedItem: false, itemAnimationCurve: easeOutCubic,
//           panelAnimationCurve: fastOutSlowIn, GlassBarThemeData (orange).

class CompactPage extends StatefulWidget {
  const CompactPage({super.key});

  @override
  State<CompactPage> createState() => _CompactPageState();
}

class _CompactPageState extends State<CompactPage> {
  late final List<GlassBarItem> _items;
  int? _selectedIndex;
  bool _autoHideEnabled = true;
  Duration _autoHideDuration = const Duration(seconds: 2);

  static const List<String> _tabLabels = <String>[
    'Home',
    'Explore',
    'Alerts',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _items = _buildItems();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useStackedLayout = constraints.maxWidth < 700;
        final panel = _CompactFrame(
          selectedIndex: _selectedIndex,
          tabLabels: _tabLabels,
          bar: GlassBar(
            items: _items,
            orientation: Axis.horizontal,
            selectedIndex: _selectedIndex,
            onTabChanged: (int? i) => setState(() => _selectedIndex = i),
            maxExtent: 400,
            expandSelectedItem: false,
            deselectOnTapWhenSelected: true,
            panelAutoHideDuration: _autoHideEnabled ? _autoHideDuration : null,
            panelShowDuration: const Duration(milliseconds: 300),
            panelHideDuration: const Duration(milliseconds: 180),
            panelAnimationCurve: Curves.fastOutSlowIn,
            itemAnimationDuration: const Duration(milliseconds: 200),
            itemAnimationCurve: Curves.easeOutCubic,
            theme: const GlassBarThemeData(
              backgroundColor: Color(0x1AF97316),
              selectedItemBackgroundColor: Color(0x33FED7AA),
              selectedItemColor: Colors.white,
              unselectedItemColor: Color(0xBFFFFFFF),
              blur: 18,
              borderRadius: 20,
              borderSide: BorderSide(
                color: Color(0x55F97316),
                width: 1.2,
              ),
              labelStyle: TextStyle(fontWeight: FontWeight.w700),
              panelBackgroundColor: Color(0x1AFED7AA),
              panelBlur: 32,
              panelBorderRadius: 16,
              panelBorderSide: BorderSide(color: Color(0x33FFFFFF)),
              barPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              panelPadding: EdgeInsets.all(14),
              boxShadows: <BoxShadow>[
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
          ),
        );

        final controls = _CompactControls(
          selectedIndex: _selectedIndex,
          itemCount: _items.length,
          autoHideEnabled: _autoHideEnabled,
          autoHideDuration: _autoHideDuration,
          onSelectIndex: (int? i) => setState(() => _selectedIndex = i),
          onAutoHideChanged: (bool v) => setState(() => _autoHideEnabled = v),
          onDurationChanged: (Duration d) =>
              setState(() => _autoHideDuration = d),
        );

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _FeatureChips(const <String>[
                'selectedIndex (controlled)',
                'panelAutoHideDuration',
                'expandSelectedItem: false',
                'itemAnimationCurve: easeOutCubic',
                'panelAnimationCurve: fastOutSlowIn',
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: useStackedLayout
                    ? Column(
                        children: <Widget>[
                          Expanded(child: panel),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 260,
                            child: controls,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: panel),
                          const SizedBox(width: 14),
                          SizedBox(width: 210, child: controls),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Reusable layout widgets ──────────────────────────────────────────────────

class _PhoneMockup extends StatelessWidget {
  const _PhoneMockup({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 660,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: const Color(0xFF090E1C),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38.5),
        child: child,
      ),
    );
  }
}

class _DesktopFrame extends StatelessWidget {
  const _DesktopFrame({
    required this.sidebar,
    required this.content,
  });

  final Widget sidebar;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: <Widget>[
            IntrinsicWidth(child: sidebar),
            Container(
              width: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _CompactFrame extends StatelessWidget {
  const _CompactFrame({
    required this.bar,
    required this.selectedIndex,
    required this.tabLabels,
  });

  final Widget bar;
  final int? selectedIndex;
  final List<String> tabLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            selectedIndex != null ? tabLabels[selectedIndex!] : 'Tap a tab',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.35,
              children: List<Widget>.generate(
                4,
                (int i) => _ContentCard(index: i),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(child: bar),
        ],
      ),
    );
  }
}

class _CompactControls extends StatelessWidget {
  const _CompactControls({
    required this.selectedIndex,
    required this.itemCount,
    required this.autoHideEnabled,
    required this.autoHideDuration,
    required this.onSelectIndex,
    required this.onAutoHideChanged,
    required this.onDurationChanged,
  });

  final int? selectedIndex;
  final int itemCount;
  final bool autoHideEnabled;
  final Duration autoHideDuration;
  final ValueChanged<int?> onSelectIndex;
  final ValueChanged<bool> onAutoHideChanged;
  final ValueChanged<Duration> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Controls',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'selectedIndex:',
              style: TextStyle(fontSize: 11, color: Colors.white54),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: <Widget>[
                ...List<Widget>.generate(
                  itemCount,
                  (int i) => _IndexChip(
                    label: '$i',
                    selected: selectedIndex == i,
                    onTap: () => onSelectIndex(i),
                  ),
                ),
                _IndexChip(
                  label: 'null',
                  selected: selectedIndex == null,
                  onTap: () => onSelectIndex(null),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text(
                    'Auto hide panel',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Switch.adaptive(
                  value: autoHideEnabled,
                  onChanged: onAutoHideChanged,
                ),
              ],
            ),
            if (autoHideEnabled) ...<Widget>[
              const Text(
                'Delay:',
                style: TextStyle(fontSize: 11, color: Colors.white54),
              ),
              Slider(
                value:
                    autoHideDuration.inMilliseconds.toDouble().clamp(500, 5000),
                min: 500,
                max: 5000,
                divisions: 18,
                onChanged: (double v) =>
                    onDurationChanged(Duration(milliseconds: v.round())),
              ),
              Text(
                '${autoHideDuration.inMilliseconds} ms',
                style: const TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              'Active index: ${selectedIndex?.toString() ?? 'null'}',
              style: const TextStyle(fontSize: 11, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _FeatureChips extends StatelessWidget {
  const _FeatureChips(this.features);

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: features
          .map(
            (String f) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                ),
              ),
              child: Text(
                f,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Colors.white54,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: value
              ? Colors.purpleAccent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value
                ? Colors.purpleAccent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: value ? Colors.purpleAccent : Colors.white38,
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _IndexChip extends StatelessWidget {
  const _IndexChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? Colors.orange.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? Colors.orange.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? Colors.orange : Colors.white54,
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.index});

  final int index;

  static const List<Color> _accents = <Color>[
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.lightGreenAccent,
    Colors.pinkAccent,
    Colors.amberAccent,
  ];

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: <Color>[
            Colors.white.withValues(alpha: 0.11),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.09),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome_rounded,
          size: 26,
          color: _accents[index % _accents.length].withValues(alpha: 0.8),
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + index * 25),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: child,
    );
  }
}

class _PanelContent extends StatelessWidget {
  const _PanelContent({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (String item) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              children: <Widget>[
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  item,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppBackground extends StatelessWidget {
  const _AppBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF0F1729),
            Color(0xFF0A2540),
            Color(0xFF062A26),
          ],
        ),
      ),
    );
  }
}
