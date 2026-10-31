import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:clue_map/clue_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _clueMapPlugin = ClueMap();

  // Example location: Paris, France
  double _latitude = 48.8566;
  double _longitude = 2.3522;
  MapTheme _theme = MapTheme.minimalist;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _clueMapPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ClueMapCard Fast Example'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Running on: $_platformVersion',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ClueMapCard(
                        height: 320,
                        latitude: _latitude,
                        longitude: _longitude,
                        theme: _theme,
                        cornerRadius: 12,
                        initialZoom: 10,
                        markerSize: 52,
                        boundaryFillColor: Colors.indigo.withValues(alpha: 0.3),
                        boundaryStrokeColor: Colors.indigo,
                        boundaryStrokeWidth: 2,
                        onMapTap: (latLng) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Tapped at: ${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Location: $_latitude, $_longitude',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Paris, France
                        _latitude = 48.8566;
                        _longitude = 2.3522;
                      });
                    },
                    child: const Text('Paris'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Tokyo, Japan
                        _latitude = 35.6762;
                        _longitude = 139.6503;
                      });
                    },
                    child: const Text('Tokyo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // New York, USA
                        _latitude = 40.7128;
                        _longitude = -74.0060;
                      });
                    },
                    child: const Text('New York'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Theme: '),
                  DropdownButton<MapTheme>(
                    value: _theme,
                    items: const [
                      DropdownMenuItem(
                        value: MapTheme.minimalist,
                        child: Text('Minimalist'),
                      ),
                      DropdownMenuItem(
                        value: MapTheme.dark,
                        child: Text('Dark'),
                      ),
                      DropdownMenuItem(
                        value: MapTheme.retro,
                        child: Text('Retro'),
                      ),
                      DropdownMenuItem(
                        value: MapTheme.standard,
                        child: Text('Standard'),
                      ),
                    ],
                    onChanged: (newTheme) {
                      if (newTheme != null) {
                        setState(() => _theme = newTheme);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
