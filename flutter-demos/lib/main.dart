import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui' show FlutterView;
import 'dart:ui_web' as ui_web;

import 'package:material_ui/material_ui.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

import 'demos/button_demos.dart';
import 'demos/checkbox_demos.dart';

/// All demos the website can embed, keyed by the `demo` value of the `flutterDemo` macro.
final Map<String, WidgetBuilder> demos = {
  ...buttonDemos,
  ...checkboxDemos,
};

/// Shared by all views: the website toggles light and dark mode for every demo at once.
final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

/// Runs in multi-view mode: the website adds one view per demo with `app.addView(...)`.
void main() {
  globalContext.setProperty(
    'sbbFlutterDemosSetDarkMode'.toJS,
    ((JSBoolean dark) => isDarkMode.value = dark.toDart).toJS,
  );
  runWidget(const DemoViews());
}

/// Data the website passes as `initialData` to `app.addView(...)`.
extension type DemoViewData._(JSObject _) implements JSObject {
  external String get demo;
  external bool? get dark;
}

class DemoViews extends StatefulWidget {
  const DemoViews({super.key});

  @override
  State<DemoViews> createState() => _DemoViewsState();
}

class _DemoViewsState extends State<DemoViews> with WidgetsBindingObserver {
  List<FlutterView> _views = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called when the website adds or removes a view.
  @override
  void didChangeMetrics() => setState(_updateViews);

  void _updateViews() {
    _views = WidgetsBinding.instance.platformDispatcher.views.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(
      views: [
        for (final view in _views) View(view: view, child: DemoApp(data: _initialData(view.viewId))),
      ],
    );
  }

  DemoViewData _initialData(int viewId) {
    final data = ui_web.views.getInitialData(viewId) as DemoViewData;
    if (data.dark != null) isDarkMode.value = data.dark!;
    return data;
  }
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key, required this.data});

  final DemoViewData data;

  @override
  Widget build(BuildContext context) {
    final builder = demos[data.demo];
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, dark, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: SBBTheme.light(),
        darkTheme: SBBTheme.dark(),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        // Transparent, so the website's light or dark box shows through like it does for the images.
        color: Colors.transparent,
        home: Material(
          type: MaterialType.transparency,
          child: builder != null ? Builder(builder: builder) : Center(child: Text('Unknown demo: ${data.demo}')),
        ),
      ),
    );
  }
}
