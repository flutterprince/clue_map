#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint clue_map.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'clue_map'
  s.version          = '0.0.2'
  s.summary          = 'A Flutter map plugin providing ClueMapCard.'
  s.description      = <<-DESC
A Flutter map plugin providing ClueMapCard with custom markers, theme presets (minimalist, dark, retro), and automated reverse-geocoded city boundaries.
                       DESC
  s.homepage         = 'https://github.com/flutterprince/clue_map'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Prince' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'clue_map/Sources/clue_map/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = '5.0'
end
