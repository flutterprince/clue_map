import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'googlemaparea_platform_interface.dart';

/// Web implementation of [GooglemapareaPlatform] for the [ClueMap] plugin.
class ClueMapWeb extends GooglemapareaPlatform {
  ClueMapWeb();

  static void registerWith(Registrar registrar) {
    GooglemapareaPlatform.instance = ClueMapWeb();
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
