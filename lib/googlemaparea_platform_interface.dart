import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'googlemaparea_method_channel.dart';

abstract class GooglemapareaPlatform extends PlatformInterface {
  /// Constructs a GooglemapareaPlatform.
  GooglemapareaPlatform() : super(token: _token);

  static final Object _token = Object();

  static GooglemapareaPlatform _instance = MethodChannelGooglemaparea();

  /// The default instance of [GooglemapareaPlatform] to use.
  ///
  /// Defaults to [MethodChannelGooglemaparea].
  static GooglemapareaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GooglemapareaPlatform] when
  /// they register themselves.
  static set instance(GooglemapareaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
