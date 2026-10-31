import 'package:flutter_test/flutter_test.dart';
import 'package:clue_map/clue_map.dart';
import 'package:clue_map/googlemaparea_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGooglemapareaPlatform
    with MockPlatformInterfaceMixin
    implements GooglemapareaPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GooglemapareaPlatform initialPlatform = GooglemapareaPlatform.instance;

  test('$MethodChannelGooglemaparea is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGooglemaparea>());
  });

  test('getPlatformVersion', () async {
    ClueMap clueMapPlugin = ClueMap();
    MockGooglemapareaPlatform fakePlatform = MockGooglemapareaPlatform();
    GooglemapareaPlatform.instance = fakePlatform;

    expect(await clueMapPlugin.getPlatformVersion(), '42');
  });
}
