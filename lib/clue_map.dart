export 'src/clue_map_card.dart';
export 'googlemaparea_platform_interface.dart';

import 'googlemaparea_platform_interface.dart';

/// Global configuration and diagnostics for the [ClueMap] plugin.
class ClueMap {
  static String? _googleMapsApiKey;
  static String _userAgent = 'ClueMapFlutterPlugin/1.0';

  /// Securely initializes global parameters for [ClueMap].
  ///
  /// Pass [googleMapsApiKey] (or [apiKey]) dynamically at runtime or read it securely from `--dart-define`.
  static void initialize({
    String? googleMapsApiKey,
    String? apiKey,
    String? userAgent,
  }) {
    final key = googleMapsApiKey ?? apiKey;
    if (key != null && key.isNotEmpty) {
      _googleMapsApiKey = key;
    }
    if (userAgent != null && userAgent.isNotEmpty) {
      _userAgent = userAgent;
    }
  }

  /// Returns the configured global Google Maps API key (if set).
  static String? get googleMapsApiKey => _googleMapsApiKey;
  static String? get apiKey => _googleMapsApiKey;

  /// Returns the configured User-Agent string.
  static String get userAgent => _userAgent;

  /// Returns the current platform version string.
  Future<String?> getPlatformVersion() {
    return GooglemapareaPlatform.instance.getPlatformVersion();
  }
}
