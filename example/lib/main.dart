import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glass_bar/glass_bar.dart';

void main() {
  runApp(const GlassBarFeatureApp());
}

class GlassBarFeatureApp extends StatelessWidget {
  const GlassBarFeatureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Bar Feature Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF070A12),
      ),
      home: const FeatureShowcaseScreen(),
    );
  }
}

class FeatureShowcaseScreen extends StatefulWidget {
  const FeatureShowcaseScreen({super.key});

  @override
  State<FeatureShowcaseScreen> createState() => _FeatureShowcaseScreenState();
}

class _FeatureShowcaseScreenState extends State<FeatureShowcaseScreen> {
  static const double _kPanelWidthMin = 180;
  static const double _kPanelWidthMax = 360;
  static const double _kHorizontalExtentMin = 280;
  static const double _kHorizontalExtentMax = 760;
  static const double _kVerticalExtentMin = 280;
  static const double _kVerticalExtentMax = 560;

  late final List<GlassBarItem> _items;

  Axis _orientation = Axis.horizontal;
  bool _rotateLabelInVertical = true;
  bool _iconAfterLabel = false;
  bool _expandSelectedItem = true;
  bool _deselectOnTapWhenSelected = true;
  bool _useMaxExtent = true;
  bool _useCustomTheme = true;
  bool _useControlledMode = false;
  bool _useAutoHide = false;

  int? _uncontrolledIndex = 0;
  int? _controlledIndex;

  double _horizontalMaxExtent = 540;
  double _verticalMaxExtent = 420;
  double _verticalPanelMaxWidth = 250;

  Duration _itemAnimationDuration = const Duration(milliseconds: 280);
  Curve _itemAnimationCurve = Curves.easeInOut;
  Duration _panelShowDuration = const Duration(milliseconds: 450);
  Duration _panelHideDuration = const Duration(milliseconds: 250);
  Curve _panelAnimationCurve = Curves.easeOutCubic;
  Duration _panelAutoHideDuration = const Duration(seconds: 2);

  final List<_CurvePreset> _curvePresets = const <_CurvePreset>[
    _CurvePreset('Ease In Out', Curves.easeInOut),
    _CurvePreset('Ease Out Cubic', Curves.easeOutCubic),
    _CurvePreset('Fast Out Slow In', Curves.fastOutSlowIn),
    _CurvePreset('Elastic Out', Curves.elasticOut),
  ];

  int? get _effectiveSelectedIndex =>
      _useControlledMode ? _controlledIndex : _uncontrolledIndex;

  @override
  void initState() {
    super.initState();
    _items = <GlassBarItem>[
      GlassBarItem(
        iconData: Icons.dashboard_customize_rounded,
        labelText: 'Workspace',
        tooltip: 'Workspace tools',
        semanticLabel: 'Workspace tab',
        longPressHint: 'Opens workspace quick panel',
        panelContent: _buildPanelSection(
          'Workspace',
          const <String>[
            'Boards',
            'Roadmap',
            'Automation',
            'Team Status',
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.bolt_rounded,
        labelText: 'Shortcuts',
        tooltip: 'Productivity shortcuts',
        semanticLabel: 'Shortcuts tab',
        longPressHint: 'Opens productivity shortcuts panel',
        panelContent: _buildPanelSection(
          'Quick Actions',
          const <String>[
            'New Task',
            'Start Focus Timer',
            'Capture Idea',
            'Share Update',
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.insights_rounded,
        labelText: 'Insights',
        tooltip: 'Insights and analytics',
        semanticLabel: 'Insights tab',
        longPressHint: 'Opens analytics panel',
        panelContent: _buildPanelSection(
          'Analytics',
          const <String>[
            'Weekly velocity +12%',
            'On-time delivery 94%',
            'Blocked tasks: 3',
            'Team load balanced',
          ],
        ),
      ),
      GlassBarItem(
        iconData: Icons.settings_suggest_rounded,
        labelText: 'Settings',
        tooltip: 'Project settings',
        semanticLabel: 'Settings tab',
        longPressHint: 'Opens settings panel',
        panelContent: _buildPanelSection(
          'Configuration',
          const <String>[
            'Notifications',
            'Permissions',
            'Integrations',
            'Security',
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = _orientation == Axis.horizontal;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const _FeatureBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: _buildShowcaseArea(context, isHorizontal),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: _buildControlPanel(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowcaseArea(BuildContext context, bool isHorizontal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Glass Bar Feature Showcase',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap each tab to inspect panel behavior, layout, animation, and theme.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 22),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Colors.white.withValues(alpha: 0.06),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: isHorizontal
                ? Column(
                    children: <Widget>[
                      Expanded(child: _buildContentCards()),
                      const SizedBox(height: 20),
                      _buildDemoBar(),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      _buildDemoBar(),
                      const SizedBox(width: 20),
                      Expanded(child: _buildContentCards()),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentCards() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: List<Widget>.generate(6, (int index) {
        final List<Color> accent = <Color>[
          Colors.cyanAccent,
          Colors.purpleAccent,
          Colors.orangeAccent,
          Colors.lightGreenAccent,
        ];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: <Color>[
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.04),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 34,
              color: accent[index % accent.length].withValues(alpha: 0.85),
            ),
          ),
        ).animate().fadeIn(delay: (100 + (index * 30)).ms);
      }),
    );
  }

  Widget _buildDemoBar() {
    final bool isHorizontal = _orientation == Axis.horizontal;
    return GlassBar(
      items: _items,
      orientation: _orientation,
      selectedIndex: _useControlledMode ? _controlledIndex : null,
      initialIndex: _useControlledMode ? null : _uncontrolledIndex,
      onTabChanged: (int? index) {
        if (_useControlledMode) {
          setState(() => _controlledIndex = index);
        } else {
          setState(() => _uncontrolledIndex = index);
        }
      },
      rotateLabelInVertical: _rotateLabelInVertical,
      iconAfterLabel: _iconAfterLabel,
      maxExtent: _useMaxExtent
          ? (isHorizontal ? _horizontalMaxExtent : _verticalMaxExtent)
          : null,
      theme: _useCustomTheme ? _buildCustomTheme() : null,
      itemAnimationDuration: _itemAnimationDuration,
      itemAnimationCurve: _itemAnimationCurve,
      panelShowDuration: _panelShowDuration,
      panelHideDuration: _panelHideDuration,
      panelAutoHideDuration: _useAutoHide ? _panelAutoHideDuration : null,
      panelAnimationCurve: _panelAnimationCurve,
      deselectOnTapWhenSelected: _deselectOnTapWhenSelected,
      expandSelectedItem: _expandSelectedItem,
      verticalPanelMaxWidth: _verticalPanelMaxWidth,
    );
  }

  GlassBarThemeData _buildCustomTheme() {
    return GlassBarThemeData(
      backgroundColor: const Color(0x1F88D8FF),
      selectedItemBackgroundColor: const Color(0x33FFFFFF),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withValues(alpha: 0.75),
      blur: 22,
      borderRadius: 30,
      borderSide: BorderSide(
        color: Colors.cyanAccent.withValues(alpha: 0.35),
        width: 1.4,
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      panelBackgroundColor: const Color(0x1E89C2FF),
      panelBlur: 24,
      panelBorderRadius: 24,
      panelBorderSide: BorderSide(
        color: Colors.white.withValues(alpha: 0.3),
      ),
      boxShadows: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
      barPadding: const EdgeInsets.all(10),
      panelPadding: const EdgeInsets.all(18),
    );
  }

  Widget _buildPanelSection(String title, List<String> points) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...points.map(
          (String point) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 14.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: ListView(
        children: <Widget>[
          Text(
            'Feature Controls',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),
          _buildSegmentedOrientation(),
          const SizedBox(height: 12),
          _switchTile(
            title: 'Controlled mode (selectedIndex)',
            value: _useControlledMode,
            onChanged: (bool v) {
              setState(() {
                _useControlledMode = v;
                _controlledIndex = v ? _controlledIndex : null;
              });
            },
          ),
          _switchTile(
            title: 'Rotate label in vertical',
            value: _rotateLabelInVertical,
            onChanged: (bool v) => setState(() => _rotateLabelInVertical = v),
          ),
          _switchTile(
            title: 'Icon after label',
            value: _iconAfterLabel,
            onChanged: (bool v) => setState(() => _iconAfterLabel = v),
          ),
          _switchTile(
            title: 'Expand selected item',
            value: _expandSelectedItem,
            onChanged: (bool v) => setState(() => _expandSelectedItem = v),
          ),
          _switchTile(
            title: 'Deselect on same tab tap',
            value: _deselectOnTapWhenSelected,
            onChanged: (bool v) =>
                setState(() => _deselectOnTapWhenSelected = v),
          ),
          _switchTile(
            title: 'Use maxExtent',
            value: _useMaxExtent,
            onChanged: (bool v) => setState(() => _useMaxExtent = v),
          ),
          _switchTile(
            title: 'Use custom theme',
            value: _useCustomTheme,
            onChanged: (bool v) => setState(() => _useCustomTheme = v),
          ),
          _switchTile(
            title: 'Panel auto hide',
            value: _useAutoHide,
            onChanged: (bool v) => setState(() => _useAutoHide = v),
          ),
          const SizedBox(height: 6),
          _sliderTile(
            title: 'Vertical panel max width',
            value: _verticalPanelMaxWidth,
            min: _kPanelWidthMin,
            max: _kPanelWidthMax,
            onChanged: (double v) => setState(() => _verticalPanelMaxWidth = v),
          ),
          _sliderTile(
            title: 'Horizontal max extent',
            value: _horizontalMaxExtent,
            min: _kHorizontalExtentMin,
            max: _kHorizontalExtentMax,
            onChanged: (double v) => setState(() => _horizontalMaxExtent = v),
          ),
          _sliderTile(
            title: 'Vertical max extent',
            value: _verticalMaxExtent,
            min: _kVerticalExtentMin,
            max: _kVerticalExtentMax,
            onChanged: (double v) => setState(() => _verticalMaxExtent = v),
          ),
          _sliderTile(
            title: 'Item animation (ms)',
            value: _itemAnimationDuration.inMilliseconds.toDouble(),
            min: 100,
            max: 700,
            onChanged: (double v) => setState(
              () => _itemAnimationDuration = Duration(milliseconds: v.round()),
            ),
          ),
          _sliderTile(
            title: 'Panel show duration (ms)',
            value: _panelShowDuration.inMilliseconds.toDouble(),
            min: 150,
            max: 900,
            onChanged: (double v) => setState(
                () => _panelShowDuration = Duration(milliseconds: v.round())),
          ),
          _sliderTile(
            title: 'Panel hide duration (ms)',
            value: _panelHideDuration.inMilliseconds.toDouble(),
            min: 100,
            max: 700,
            onChanged: (double v) => setState(
                () => _panelHideDuration = Duration(milliseconds: v.round())),
          ),
          _sliderTile(
            title: 'Panel auto hide (ms)',
            value: _panelAutoHideDuration.inMilliseconds.toDouble(),
            min: 800,
            max: 6000,
            onChanged: (double v) => setState(
              () => _panelAutoHideDuration = Duration(milliseconds: v.round()),
            ),
          ),
          const SizedBox(height: 10),
          _curveSelector(
            title: 'Item animation curve',
            value: _itemAnimationCurve,
            onChanged: (Curve curve) =>
                setState(() => _itemAnimationCurve = curve),
          ),
          const SizedBox(height: 8),
          _curveSelector(
            title: 'Panel animation curve',
            value: _panelAnimationCurve,
            onChanged: (Curve curve) =>
                setState(() => _panelAnimationCurve = curve),
          ),
          const SizedBox(height: 10),
          Text(
            'Current selected index: ${_effectiveSelectedIndex?.toString() ?? 'null'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedOrientation() {
    return SegmentedButton<Axis>(
      segments: const <ButtonSegment<Axis>>[
        ButtonSegment<Axis>(
          value: Axis.horizontal,
          icon: Icon(Icons.swap_horiz_rounded),
          label: Text('Horizontal'),
        ),
        ButtonSegment<Axis>(
          value: Axis.vertical,
          icon: Icon(Icons.swap_vert_rounded),
          label: Text('Vertical'),
        ),
      ],
      selected: <Axis>{_orientation},
      onSelectionChanged: (Set<Axis> selection) {
        setState(() {
          _orientation = selection.first;
        });
      },
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      dense: true,
      value: value,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      onChanged: onChanged,
    );
  }

  Widget _sliderTile({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$title: ${value.round()}'),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _curveSelector({
    required String title,
    required Curve value,
    required ValueChanged<Curve> onChanged,
  }) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title)),
        DropdownButton<Curve>(
          value: value,
          items: _curvePresets
              .map(
                (_CurvePreset preset) => DropdownMenuItem<Curve>(
                  value: preset.curve,
                  child: Text(preset.label),
                ),
              )
              .toList(),
          onChanged: (Curve? next) {
            if (next != null) {
              onChanged(next);
            }
          },
        ),
      ],
    );
  }
}

class _FeatureBackground extends StatelessWidget {
  const _FeatureBackground();

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
            Color(0xFF062A26)
          ],
        ),
      ),
    );
  }
}

class _CurvePreset {
  const _CurvePreset(this.label, this.curve);

  final String label;
  final Curve curve;
}
