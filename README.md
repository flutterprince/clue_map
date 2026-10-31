# clue_map

[![pub package](https://img.shields.io/pub/v/clue_map.svg)](https://pub.dev/packages/clue_map)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue)](https://flutter.dev)

A hyper-fast, zero-lag Flutter map plugin providing the **`ClueMapCard`** widget — featuring custom pin markers (Network, Asset, or Raw Bytes), built-in visual themes (Minimalist, Dark, Retro, Standard), automated reverse-geocoded city boundary overlays using OpenStreetMap Nominatim, and in-memory RAM caching.

Supports **Android**, **iOS**, **macOS**, **Windows**, **Linux**, and **Web**.

---

## Key Features

- ⚡ **Zero-Lag In-Memory Caching**: Global RAM caches (`_pinIconCache` and `_geojsonBoundaryCache`) deliver instant **0-millisecond** marker and boundary renders when scrolling or switching locations.
- 🎨 **Visual Theme Presets (`MapTheme`)**: Select built-in visual themes (`MapTheme.minimalist`, `MapTheme.dark`, `MapTheme.retro`, `MapTheme.standard`) or supply custom Google Maps JSON styling.
- 📌 **Multiple Marker Pin Sources**: Load marker pins from network URLs (`markerIcon`), local Flutter assets (`markerAsset`), or raw image byte arrays (`markerBytes`) with custom anchor points and dynamic pixel resizing.
- 🗺️ **Automated City Boundary Overlay**: Queries OpenStreetMap Nominatim reverse-geocoding API to render precise boundary polygons (supporting `Polygon` and `MultiPolygon` GeoJSON with holes).
- 🎯 **Interactivity & Callbacks**: Handles `onMapTap`, `onMarkerTap`, `onMapCreated`, `onBoundaryLoaded`, and `onBoundaryError`.
- 🛡️ **Cost Guard & Rebuild Prevention**: Animates camera and uses `keepAlive` state in `ListView`s to prevent expensive duplicate Google Maps API load charges.
- 🎨 **Container Customization**: Fully customizable with `BoxDecoration` (shadows, borders, gradients), margins, and padding.

---

## Installation

Add `clue_map` to your project's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  clue_map: ^0.0.1
```

Run in terminal:
```bash
flutter pub get
```

---

## Platform Setup (Google Maps API Key)

#### 🤖 Android (`android/local.properties` & `AndroidManifest.xml`)
Add your key to `android/local.properties`:
```properties
MAPS_API_KEY=AIzaSyYourGoogleMapsApiKey
```

In `android/app/build.gradle.kts`:
```kotlin
val localProperties = java.util.Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.inputStream())
}
val mapsApiKey = localProperties.getProperty("MAPS_API_KEY") ?: ""

android {
    defaultConfig {
        manifestPlaceholders["mapsApiKey"] = mapsApiKey
    }
}
```

In `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${mapsApiKey}" />
```

#### 🍎 iOS (`ios/Runner/AppDelegate.swift`)
In `ios/Runner/AppDelegate.swift`:
```swift
import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### 🌐 Web (`web/index.html`)
In `web/index.html`:
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY"></script>
```

---

## Quick Start & Usage Examples

### 1. Global Plugin Initialization (`main.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:clue_map/clue_map.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize global settings securely
  ClueMap.initialize(
    googleMapsApiKey: const String.fromEnvironment('MAPS_API_KEY'),
    userAgent: 'MyApp/1.0',
  );

  runApp(const MyApp());
}
```

---

### 2. Simple Minimalist Map Card

```dart
import 'package:flutter/material.dart';
import 'package:clue_map/clue_map.dart';

class SimpleMapExample extends StatelessWidget {
  const SimpleMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ClueMapCard(
          height: 350,
          width: 350,
          latitude: 48.8566,  // Paris Latitude
          longitude: 2.3522,  // Paris Longitude
          theme: MapTheme.minimalist,
          cornerRadius: 16,
          markerSize: 52,
        ),
      ),
    );
  }
}
```

---

### 3. Dark Theme Card with Local Asset Icon & Shadows

```dart
import 'package:flutter/material.dart';
import 'package:clue_map/clue_map.dart';

class DarkThemeMapExample extends StatelessWidget {
  const DarkThemeMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: ClueMapCard(
          height: 380,
          width: 360,
          latitude: 35.6762,   // Tokyo
          longitude: 139.6503,
          theme: MapTheme.dark,
          markerAsset: 'assets/images/custom_pin.png', // Local asset pin
          markerSize: 56,
          boundaryFillColor: Colors.deepPurple.withValues(alpha: 0.35),
          boundaryStrokeColor: Colors.purpleAccent,
          boundaryStrokeWidth: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.5)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          onMapTap: (latLng) {
            debugPrint('Tapped at: ${latLng.latitude}, ${latLng.longitude}');
          },
          onMarkerTap: () {
            debugPrint('Marker pin clicked!');
          },
        ),
      ),
    );
  }
}
```

---

### 4. Retro Theme Card with Dynamic Location Switcher

```dart
import 'package:flutter/material.dart';
import 'package:clue_map/clue_map.dart';

class RetroMapExample extends StatefulWidget {
  const RetroMapExample({super.key});

  @override
  State<RetroMapExample> createState() => _RetroMapExampleState();
}

class _RetroMapExampleState extends State<RetroMapExample> {
  double _lat = 40.7128; // New York
  double _lng = -74.0060;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClueMapCard(
            height: 360,
            latitude: _lat,
            longitude: _lng,
            theme: MapTheme.retro,
            boundaryFillColor: const Color(0x55B9D3C2),
            boundaryStrokeColor: const Color(0xFF6B8E23),
            keepAlive: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setState(() { _lat = 40.7128; _lng = -74.0060; }),
                child: const Text('New York'),
              ),
              ElevatedButton(
                onPressed: () => setState(() { _lat = 48.8566; _lng = 2.3522; }),
                child: const Text('Paris'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Complete API Reference (`ClueMapCard`)

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Location & Key** | | | |
| `latitude` | `double` | **Required** | Map center latitude. |
| `longitude` | `double` | **Required** | Map center longitude. |
| `googleMapsApiKey` | `String?` | `null` | Optional Google Maps API key override. |
| **Marker Pin** | | | |
| `markerIcon` | `String?` | Default URL | Network URL for custom marker pin. |
| `markerAsset` | `String?` | `null` | Asset path (e.g. `'assets/pin.png'`) for marker pin. |
| `markerBytes` | `Uint8List?` | `null` | Raw byte array for marker pin image. |
| `markerSize` | `int` | `48` | Pixel target size for resized pin. |
| `markerAnchor` | `Offset` | `Offset(0.5, 1.0)` | Pin anchor point offset. |
| `showMarker` | `bool` | `true` | Show or hide pin marker. |
| **Theme & Boundary** | | | |
| `theme` | `MapTheme` | `MapTheme.minimalist` | Preset theme (`minimalist`, `dark`, `retro`, `standard`). |
| `mapStyle` | `String?` | `null` | Custom JSON style string (overrides `theme`). |
| `boundaryFillColor` | `Color?` | Green 35% alpha | Polygon fill color. |
| `boundaryStrokeColor` | `Color?` | `Colors.green` | Polygon border stroke color. |
| `boundaryStrokeWidth` | `int` | `2` | Polygon stroke width. |
| `nominatimZoom` | `int` | `10` | Reverse-geocode detail target (10=city/town). |
| `enableBoundary` | `bool` | `true` | Enable or disable city boundary fetching. |
| **Performance & Layout** | | | |
| `keepAlive` | `bool` | `true` | Preserve map state in scrollable views to save API load costs. |
| `width` / `height` | `double?` | `null` | Container dimensions. |
| `cornerRadius` | `double` | `0` | Border radius clipping. |
| `decoration` | `BoxDecoration?` | `null` | Outer container decoration (shadow, border, etc.). |
| `margin` / `padding` | `EdgeInsets?` | `null` | Container margin and padding. |
| **Callbacks** | | | |
| `onMapCreated` | `Function(GoogleMapController)` | `null` | Controller instance callback. |
| `onMapTap` | `Function(LatLng)` | `null` | Callback when map is tapped. |
| `onMarkerTap` | `VoidCallback` | `null` | Callback when marker pin is tapped. |
| `onBoundaryLoaded` | `Function(Set<Polygon>)` | `null` | Callback when boundary polygon is loaded. |
| `onBoundaryError` | `Function(Object)` | `null` | Callback when boundary loading fails. |

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
