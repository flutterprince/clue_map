# googlemaparea

A hyper-customizable, cross-platform Flutter plugin providing the **`MapClueCard`** widget — a minimalist Google Maps widget featuring custom marker icons (Network, Asset, or Raw Bytes), theme presets (Minimalist, Dark, Retro, Standard), interactivity callbacks, and automatic reverse-geocoded city boundary overlays using OpenStreetMap Nominatim API.

Supports **Android**, **iOS**, **macOS**, **Windows**, **Linux**, and **Web**.

---

## Features

- **Theme Presets (`MapTheme`)**: Select built-in visual themes (`MapTheme.minimalist`, `MapTheme.dark`, `MapTheme.retro`, `MapTheme.standard`) or supply custom Google Maps JSON styling.
- **Multiple Marker Pin Sources**: Pass network URLs (`markerIcon`), local Flutter asset paths (`markerAsset`), or raw image bytes (`markerBytes`) with customizable pin anchor points and pixel resizing.
- **Automatic City Boundary Polygon**: Queries OpenStreetMap Nominatim reverse-geocoding API to render precise boundary polygons (supporting `Polygon` and `MultiPolygon` GeoJSON).
- **Interactivity & Callbacks**: Handles `onMapTap`, `onMarkerTap`, `onMapCreated`, `onBoundaryLoaded`, and `onBoundaryError`.
- **Card Decoration**: Pass custom `BoxDecoration` (shadows, borders, gradients), margins, and padding.

---

## Installation

Add `googlemaparea` to your `pubspec.yaml`:

```yaml
dependencies:
  googlemaparea:
    path: ../path/to/googlemaparea # or version from pub.dev
```

---

## Usage Examples

### 1. Simple Minimalist Card (Network Icon)

```dart
import 'package:flutter/material.dart';
import 'package:googlemaparea/googlemaparea.dart';

class SimpleCardExample extends StatelessWidget {
  const SimpleCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapClueCard(
      height: 300,
      width: double.infinity,
      latitude: 48.8566,  // Paris
      longitude: 2.3522,
      cornerRadius: 16,
      theme: MapTheme.minimalist,
    );
  }
}
```

### 2. Dark Theme Card with Local Asset Icon & Callbacks

```dart
import 'package:flutter/material.dart';
import 'package:googlemaparea/googlemaparea.dart';

class DarkMapCardExample extends StatelessWidget {
  const DarkMapCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MapClueCard(
      height: 350,
      latitude: 35.6762,   // Tokyo
      longitude: 139.6503,
      theme: MapTheme.dark,
      markerAsset: 'assets/images/custom_pin.png', // Local asset
      markerSize: 52,
      boundaryFillColor: Colors.deepPurple.withValues(alpha: 0.4),
      boundaryStrokeColor: Colors.deepPurpleAccent,
      boundaryStrokeWidth: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      onMapTap: (latLng) {
        print('Map tapped at: ${latLng.latitude}, ${latLng.longitude}');
      },
      onMarkerTap: () {
        print('Marker pin clicked!');
      },
    );
  }
}
```

### 3. Retro Vintage Theme Card

```dart
import 'package:flutter/material.dart';
import 'package:googlemaparea/googlemaparea.dart';

class RetroCardExample extends StatelessWidget {
  const RetroCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapClueCard(
      height: 320,
      latitude: 40.7128,  // New York
      longitude: -74.0060,
      theme: MapTheme.retro,
      boundaryFillColor: Color(0x55B9D3C2),
      boundaryStrokeColor: Color(0xFF6B8E23),
      boundaryStrokeWidth: 2,
    );
  }
}
```

---

## Complete Parameter Customization Reference (`MapClueCard`)

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Location** | | | |
| `latitude` | `double` | **Required** | Latitude of map center & location. |
| `longitude` | `double` | **Required** | Longitude of map center & location. |
| **Marker Pin** | | | |
| `markerIcon` | `String?` | Default URL | Network URL for custom marker pin. |
| `markerAsset` | `String?` | `null` | Asset path (e.g. `'assets/pin.png'`) for marker pin. |
| `markerBytes` | `Uint8List?` | `null` | Raw byte array for marker pin image. |
| `markerSize` | `int` | `48` | Pixel target size for resized pin. |
| `markerAnchor` | `Offset` | `Offset(0.5, 1.0)` | Pin anchor offset. |
| `showMarker` | `bool` | `true` | Show or hide pin marker. |
| **Theme & Styling** | | | |
| `theme` | `MapTheme` | `MapTheme.minimalist` | Preset theme (`minimalist`, `dark`, `retro`, `standard`, `custom`). |
| `mapStyle` | `String?` | `null` | Custom JSON style string (overrides `theme`). |
| `boundaryFillColor` | `Color?` | Green 35% opacity | Fill color for boundary polygon. |
| `boundaryStrokeColor` | `Color?` | `Colors.green` | Border color for boundary polygon. |
| `boundaryStrokeWidth` | `int` | `2` | Border width of boundary polygon. |
| `nominatimZoom` | `int` | `10` | Reverse-geocode detail target (10=city/town). |
| **Layout & Decoration** | | | |
| `width` | `double?` | `null` | Container width. |
| `height` | `double?` | `null` | Container height. |
| `cornerRadius` | `double` | `0` | Card border clip radius. |
| `decoration` | `BoxDecoration?` | `null` | Custom container decoration (shadow, border, etc.). |
| `margin` | `EdgeInsetsGeometry?` | `null` | Card margin. |
| `padding` | `EdgeInsetsGeometry?` | `null` | Card inner padding. |
| **Callbacks** | | | |
| `onMapCreated` | `Function(GoogleMapController)?` | `null` | Controller callback. |
| `onMapTap` | `Function(LatLng)?` | `null` | Callback when map is tapped. |
| `onMarkerTap` | `VoidCallback?` | `null` | Callback when marker pin is tapped. |
| `onBoundaryLoaded` | `Function(Set<Polygon>)?` | `null` | Callback when boundary polygon is loaded. |
| `onBoundaryError` | `Function(Object)?` | `null` | Callback when boundary fails to load. |

---

## License

MIT
