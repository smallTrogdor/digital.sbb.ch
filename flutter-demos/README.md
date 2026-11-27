# sbb_flutter_demos

Live demos of the SBB Design System Mobile (Flutter) for digital.sbb.ch.

The app runs in Flutter web multi-view mode. `src/assets/js/flutter-demos.js` starts one engine per page
and adds one view per `flutterDemo` macro call. The macro's `demo` value selects a builder from `demos`
in `lib/main.dart`.

Build into the website: `npm run flutter:build` (from the repository root).
