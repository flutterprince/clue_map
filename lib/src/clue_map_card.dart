import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:http/http.dart' as http;

import '../clue_map.dart';

/// Preset visual themes for [ClueMapCard].
enum MapTheme {
  /// Light minimalist silhouette style (default).
  minimalist,

  /// Dark mode silhouette style.
  dark,

  /// Retro / vintage silhouette style.
  retro,

  /// Standard Google Maps style with full POIs and labels.
  standard,

  /// Custom style passed via [ClueMapCard.mapStyle].
  custom,
}

/// A hyper-fast, zero-lag Flutter map card widget featuring in-memory cached marker icons,
/// automated reverse-geocoded city boundary overlays (OpenStreetMap Nominatim),
/// theme presets, map callbacks, and full layout decoration.
class ClueMapCard extends StatefulWidget {
  /// Optional Google Maps API Key override for this map instance.
  final String? googleMapsApiKey;

  /// Width of the map card container.
  final double? width;

  /// Height of the map card container.
  final double? height;

  /// Center latitude for the map and reverse-geocoding boundary lookup.
  final double latitude;

  /// Center longitude for the map and reverse-geocoding boundary lookup.
  final double longitude;

  /// Network URL for the marker pin icon.
  final String? markerIcon;

  /// Flutter asset path (e.g. `'assets/images/pin.png'`) for the marker pin icon.
  final String? markerAsset;

  /// Raw byte array for the marker pin icon.
  final Uint8List? markerBytes;

  /// Anchor point for the marker pin icon (defaults to `Offset(0.5, 1.0)`).
  final Offset markerAnchor;

  /// Target pixel width to resize the marker pin icon.
  final int markerSize;

  /// Whether to show the marker pin on the map.
  final bool showMarker;

  /// Corner radius for clipping the map card borders.
  final double cornerRadius;

  /// Custom [BoxDecoration] for the outer container (shadows, borders, gradients).
  final BoxDecoration? decoration;

  /// Outer margin around the card container.
  final EdgeInsetsGeometry? margin;

  /// Inner padding around the map.
  final EdgeInsetsGeometry? padding;

  /// Initial map zoom level.
  final double initialZoom;

  /// Color used to fill the city/administrative boundary polygon.
  final Color? boundaryFillColor;

  /// Color used for the stroke of the boundary polygon.
  final Color? boundaryStrokeColor;

  /// Width of the boundary polygon stroke in logical pixels.
  final int boundaryStrokeWidth;

  /// Zoom level passed to Nominatim API to target specific administrative levels
  /// (e.g. 10 for city/town, 8 for county/state, 14 for neighborhood).
  final int nominatimZoom;

  /// Preset visual map theme ([MapTheme.minimalist], [MapTheme.dark], [MapTheme.retro], etc.).
  final MapTheme theme;

  /// Custom JSON map style string for Google Maps. Overrides [theme] if specified.
  final String? mapStyle;

  /// User-Agent header sent during Nominatim reverse-geocoding API requests.
  final String? userAgent;

  /// Whether to fetch and display the city boundary polygon.
  final bool enableBoundary;

  /// Keep-alive state when placed inside a ListView or PageView.
  final bool keepAlive;

  // Interactivity Callbacks
  /// Callback triggered when the map controller is created.
  final void Function(gmap.GoogleMapController controller)? onMapCreated;

  /// Callback triggered when the map is tapped.
  final void Function(gmap.LatLng position)? onMapTap;

  /// Callback triggered when the marker pin is tapped.
  final VoidCallback? onMarkerTap;

  /// Callback triggered when the boundary polygons finish loading.
  final void Function(Set<gmap.Polygon> polygons)? onBoundaryLoaded;

  /// Callback triggered if boundary polygon loading fails.
  final void Function(Object error)? onBoundaryError;

  // Map Controls & Gestures
  final bool zoomControlsEnabled;
  final bool rotateGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomGesturesEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool compassEnabled;
  final bool mapToolbarEnabled;
  final gmap.MinMaxZoomPreference minMaxZoomPreference;
  final gmap.CameraTargetBounds cameraTargetBounds;

  const ClueMapCard({
    super.key,
    this.googleMapsApiKey,
    this.width,
    this.height,
    required this.latitude,
    required this.longitude,
    this.markerIcon = 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/henri-4z3zw3/assets/jexqyq0w9i7r/marker.png',
    this.markerAsset,
    this.markerBytes,
    this.markerAnchor = const Offset(0.5, 1.0),
    this.markerSize = 48,
    this.showMarker = true,
    this.cornerRadius = 0,
    this.decoration,
    this.margin,
    this.padding,
    this.initialZoom = 8.0,
    this.boundaryFillColor,
    this.boundaryStrokeColor,
    this.boundaryStrokeWidth = 2,
    this.nominatimZoom = 10,
    this.theme = MapTheme.minimalist,
    this.mapStyle,
    this.userAgent,
    this.enableBoundary = true,
    this.keepAlive = true,
    this.onMapCreated,
    this.onMapTap,
    this.onMarkerTap,
    this.onBoundaryLoaded,
    this.onBoundaryError,
    this.zoomControlsEnabled = false,
    this.rotateGesturesEnabled = false,
    this.tiltGesturesEnabled = false,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.compassEnabled = false,
    this.mapToolbarEnabled = false,
    this.minMaxZoomPreference = gmap.MinMaxZoomPreference.unbounded,
    this.cameraTargetBounds = gmap.CameraTargetBounds.unbounded,
  });

  /// Default minimalist / silhouette style (Light).
  static const String _defaultMinimalStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#eef2f5"}]},
    {"elementType": "labels", "stylers": [{"visibility": "off"}]},
    {"featureType": "administrative", "stylers": [{"visibility": "off"}]},
    {"featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [{"visibility": "off"}]},
    {"featureType": "poi", "stylers": [{"visibility": "off"}]},
    {"featureType": "road", "stylers": [{"visibility": "off"}]},
    {"featureType": "transit", "stylers": [{"visibility": "off"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#c9dce8"}]},
    {"featureType": "landscape", "elementType": "geometry", "stylers": [{"color": "#eef2f5"}]}
  ]
  ''';

  /// Dark mode silhouette style.
  static const String _defaultDarkStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#212121"}]},
    {"elementType": "labels", "stylers": [{"visibility": "off"}]},
    {"featureType": "administrative", "stylers": [{"visibility": "off"}]},
    {"featureType": "poi", "stylers": [{"visibility": "off"}]},
    {"featureType": "road", "stylers": [{"visibility": "off"}]},
    {"featureType": "transit", "stylers": [{"visibility": "off"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]},
    {"featureType": "landscape", "elementType": "geometry", "stylers": [{"color": "#212121"}]}
  ]
  ''';

  /// Retro vintage silhouette style.
  static const String _defaultRetroStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#f5f1e6"}]},
    {"elementType": "labels", "stylers": [{"visibility": "off"}]},
    {"featureType": "administrative", "stylers": [{"visibility": "off"}]},
    {"featureType": "poi", "stylers": [{"visibility": "off"}]},
    {"featureType": "road", "stylers": [{"visibility": "off"}]},
    {"featureType": "transit", "stylers": [{"visibility": "off"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#b9d3c2"}]},
    {"featureType": "landscape", "elementType": "geometry", "stylers": [{"color": "#f5f1e6"}]}
  ]
  ''';

  @override
  State<ClueMapCard> createState() => _ClueMapCardState();
}

/// Backwards compatibility alias for MapClueCard.
typedef MapClueCard = ClueMapCard;

class _ClueMapCardState extends State<ClueMapCard>
    with AutomaticKeepAliveClientMixin {
  // Global static caches for zero-lag instant rendering
  static final Map<String, gmap.BitmapDescriptor> _pinIconCache = {};
  static final Map<String, Map<String, dynamic>> _geojsonBoundaryCache = {};

  gmap.GoogleMapController? _controller;
  late gmap.LatLng _position;
  gmap.BitmapDescriptor? _pinIcon;
  Set<gmap.Polygon> _cityBoundary = {};

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  void initState() {
    super.initState();
    _position = gmap.LatLng(widget.latitude, widget.longitude);
    _loadCustomPin();
    if (widget.enableBoundary) {
      _loadCityBoundary();
    }
  }

  @override
  void didUpdateWidget(covariant ClueMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final positionChanged =
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude;

    if (positionChanged) {
      final newPosition = gmap.LatLng(widget.latitude, widget.longitude);
      setState(() => _position = newPosition);
      _controller?.animateCamera(gmap.CameraUpdate.newLatLng(newPosition));
    }

    if (oldWidget.markerIcon != widget.markerIcon ||
        oldWidget.markerAsset != widget.markerAsset ||
        oldWidget.markerBytes != widget.markerBytes ||
        oldWidget.markerSize != widget.markerSize ||
        oldWidget.showMarker != widget.showMarker) {
      _loadCustomPin();
    }

    if (positionChanged ||
        oldWidget.enableBoundary != widget.enableBoundary ||
        oldWidget.nominatimZoom != widget.nominatimZoom ||
        oldWidget.boundaryFillColor != widget.boundaryFillColor ||
        oldWidget.boundaryStrokeColor != widget.boundaryStrokeColor ||
        oldWidget.boundaryStrokeWidth != widget.boundaryStrokeWidth) {
      if (widget.enableBoundary) {
        _loadCityBoundary();
      } else {
        _clearBoundary();
      }
    }
  }

  /// High-speed pin loader with in-memory caching.
  Future<void> _loadCustomPin() async {
    if (!widget.showMarker) return;

    final String cacheKey = widget.markerBytes != null
        ? 'bytes_${widget.markerBytes.hashCode}_${widget.markerSize}'
        : (widget.markerAsset != null && widget.markerAsset!.isNotEmpty)
        ? 'asset_${widget.markerAsset}_${widget.markerSize}'
        : 'url_${widget.markerIcon}_${widget.markerSize}';

    // Instant zero-lag cache lookup
    if (_pinIconCache.containsKey(cacheKey)) {
      if (mounted) {
        setState(() => _pinIcon = _pinIconCache[cacheKey]);
      }
      return;
    }

    try {
      Uint8List? bytes;

      if (widget.markerBytes != null) {
        bytes = widget.markerBytes;
      } else if (widget.markerAsset != null && widget.markerAsset!.isNotEmpty) {
        final ByteData data = await rootBundle.load(widget.markerAsset!);
        bytes = data.buffer.asUint8List();
      } else if (widget.markerIcon != null && widget.markerIcon!.isNotEmpty) {
        final response = await http
            .get(Uri.parse(widget.markerIcon!))
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          bytes = response.bodyBytes;
        }
      }

      if (bytes == null || bytes.isEmpty) return;

      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: widget.markerSize,
      );
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ByteData? resizedBytes = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (resizedBytes == null) return;

      final icon = gmap.BitmapDescriptor.bytes(
        resizedBytes.buffer.asUint8List(),
      );

      _pinIconCache[cacheKey] = icon;

      if (mounted) {
        setState(() => _pinIcon = icon);
      }
    } catch (e) {
      debugPrint('ClueMapCard: failed to load custom marker: $e');
    }
  }

  /// High-speed reverse geocoding with in-memory boundary caching.
  Future<void> _loadCityBoundary() async {
    final String cacheKey =
        '${widget.latitude.toStringAsFixed(4)}_${widget.longitude.toStringAsFixed(4)}_${widget.nominatimZoom}';

    // Instant zero-lag boundary cache lookup
    if (_geojsonBoundaryCache.containsKey(cacheKey)) {
      final geojson = _geojsonBoundaryCache[cacheKey]!;
      final polygons = _parseGeoJsonToPolygons(geojson);
      if (mounted) {
        setState(() => _cityBoundary = polygons);
        widget.onBoundaryLoaded?.call(polygons);
      }
      return;
    }

    final effectiveUserAgent = widget.userAgent ?? ClueMap.userAgent;

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${widget.latitude}&lon=${widget.longitude}'
        '&format=json&polygon_geojson=1&zoom=${widget.nominatimZoom}',
      );

      final response = await http
          .get(url, headers: {'User-Agent': effectiveUserAgent})
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        _clearBoundary();
        return;
      }

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic> || data['geojson'] == null) {
        _clearBoundary();
        return;
      }

      final geojson = data['geojson'] as Map<String, dynamic>;
      _geojsonBoundaryCache[cacheKey] = geojson;

      final polygons = _parseGeoJsonToPolygons(geojson);

      if (mounted) {
        setState(() {
          _cityBoundary = polygons;
        });
        widget.onBoundaryLoaded?.call(polygons);
      }
    } catch (e) {
      debugPrint('ClueMapCard: failed to load city boundary: $e');
      widget.onBoundaryError?.call(e);
      _clearBoundary();
    }
  }

  /// Parses GeoJSON geometry into Google Map Polygons with pre-allocated arrays.
  Set<gmap.Polygon> _parseGeoJsonToPolygons(Map<String, dynamic> geojson) {
    final Set<gmap.Polygon> polygons = {};
    final String? type = geojson['type'] as String?;
    final dynamic coordinates = geojson['coordinates'];

    if (type == null || coordinates == null || coordinates is! List) {
      return polygons;
    }

    final fillColor =
        widget.boundaryFillColor ?? Colors.green.withValues(alpha: 0.35);
    final strokeColor = widget.boundaryStrokeColor ?? Colors.green;
    int polyCounter = 0;

    gmap.Polygon? createPolygonFromRings(List rings) {
      if (rings.isEmpty) return null;

      final List exteriorRaw = rings[0] as List;
      final List<gmap.LatLng> points = List<gmap.LatLng>.generate(
        exteriorRaw.length,
        (index) {
          final pt = exteriorRaw[index] as List;
          return gmap.LatLng(
            (pt[1] as num).toDouble(),
            (pt[0] as num).toDouble(),
          );
        },
        growable: false,
      );

      if (points.isEmpty) return null;

      final List<List<gmap.LatLng>> holes = [];
      for (int i = 1; i < rings.length; i++) {
        final List holeRaw = rings[i] as List;
        final List<gmap.LatLng> holePoints = List<gmap.LatLng>.generate(
          holeRaw.length,
          (index) {
            final pt = holeRaw[index] as List;
            return gmap.LatLng(
              (pt[1] as num).toDouble(),
              (pt[0] as num).toDouble(),
            );
          },
          growable: false,
        );

        if (holePoints.isNotEmpty) {
          holes.add(holePoints);
        }
      }

      polyCounter++;
      return gmap.Polygon(
        polygonId: gmap.PolygonId('city-boundary-$polyCounter'),
        points: points,
        holes: holes,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidth: widget.boundaryStrokeWidth,
      );
    }

    if (type == 'Polygon') {
      final poly = createPolygonFromRings(coordinates);
      if (poly != null) polygons.add(poly);
    } else if (type == 'MultiPolygon') {
      for (final polyCoords in coordinates) {
        if (polyCoords is List) {
          final poly = createPolygonFromRings(polyCoords);
          if (poly != null) polygons.add(poly);
        }
      }
    }

    return polygons;
  }

  void _clearBoundary() {
    if (!mounted) return;
    setState(() => _cityBoundary = {});
  }

  String? _resolveMapStyle() {
    if (widget.mapStyle != null) return widget.mapStyle;
    switch (widget.theme) {
      case MapTheme.minimalist:
        return ClueMapCard._defaultMinimalStyle;
      case MapTheme.dark:
        return ClueMapCard._defaultDarkStyle;
      case MapTheme.retro:
        return ClueMapCard._defaultRetroStyle;
      case MapTheme.standard:
        return null;
      case MapTheme.custom:
        return widget.mapStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final effectiveStyle = _resolveMapStyle();

    Widget mapContent = gmap.GoogleMap(
      initialCameraPosition: gmap.CameraPosition(
        target: _position,
        zoom: widget.initialZoom,
      ),
      style: effectiveStyle,
      onMapCreated: (controller) {
        _controller = controller;
        widget.onMapCreated?.call(controller);
      },
      onTap: widget.onMapTap,
      markers: (!widget.showMarker || _pinIcon == null)
          ? {}
          : {
              gmap.Marker(
                markerId: const gmap.MarkerId('clue-marker'),
                position: _position,
                icon: _pinIcon!,
                anchor: widget.markerAnchor,
                onTap: widget.onMarkerTap,
              ),
            },
      polygons: _cityBoundary,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      mapToolbarEnabled: widget.mapToolbarEnabled,
      compassEnabled: widget.compassEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      minMaxZoomPreference: widget.minMaxZoomPreference,
      cameraTargetBounds: widget.cameraTargetBounds,
    );

    final double effectiveRadius = widget.cornerRadius;

    BoxDecoration containerDecoration =
        widget.decoration ??
        BoxDecoration(borderRadius: BorderRadius.circular(effectiveRadius));

    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: containerDecoration,
      clipBehavior: Clip.antiAlias,
      child: mapContent,
    );
  }
}
