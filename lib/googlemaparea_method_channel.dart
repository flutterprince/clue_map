import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'googlemaparea_platform_interface.dart';

/// An implementation of [GooglemapareaPlatform] that uses method channels.
class MethodChannelGooglemaparea extends GooglemapareaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clue_map');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
