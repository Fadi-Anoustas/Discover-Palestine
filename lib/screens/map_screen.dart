// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:palestine_cities_app/models/city.dart';
import 'package:palestine_cities_app/screens/city_details_screen.dart';
import 'package:palestine_cities_app/screens/main_screen.dart';

// Conditional import for web platform
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui_web' as ui_web;
import 'dart:js' as js;
import 'dart:html' as html;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  City? _selectedCity;
  final String _mapDivId = 'map-container';
  bool _isMapVisible = false; // Track if map should be shown

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Register the map container only when we're running on web
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(_mapDivId, (int viewId) {
        final mapDiv = html.DivElement()
          ..id = 'map'
          ..style.width = '100%'
          ..style.height = '100%';
        return mapDiv;
      });
    }
  }

  @override
  void dispose() {
    // Clean up any resources
    super.dispose();
  }

  void _toggleMap() {
    setState(() {
      _isMapVisible = !_isMapVisible;
    });

    // Initialize the map when it becomes visible
    if (_isMapVisible && kIsWeb) {
      // Give time for the DOM to update
      Future.delayed(const Duration(milliseconds: 100), () {
        js.context.callMethod('eval', ['initializeMap()']);
      });
    }
  }

  void _focusOnCity(City city) {
    if (kIsWeb && _isMapVisible) {
      js.context.callMethod('eval', [
        'window.flutterMapController.focusCity(${city.latitude}, ${city.longitude})'
      ]);
      setState(() {
        _selectedCity = city;
      });
    }
  }

  void _resetMapView() {
    if (kIsWeb && _isMapVisible) {
      js.context
          .callMethod('eval', ['window.flutterMapController.resetView()']);
      setState(() {
        _selectedCity = null;
      });
    }
  }

  void _navigateToCityDetails(City city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsScreen(city: city),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Palestine'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map toggle button - make this more compact
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _toggleMap,
                icon: Icon(_isMapVisible ? Icons.map_outlined : Icons.map),
                label: Text(_isMapVisible ? 'Hide Map' : 'Show Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Ensure green color
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // The rest of the layout goes in Expanded to use remaining space
            Expanded(
              child: Column(
                children: [
                  // Map section (conditionally visible)
                  if (_isMapVisible)
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        clipBehavior: Clip.antiAlias,
                        child: kIsWeb
                            ? HtmlElementView(viewType: _mapDivId)
                            : const Center(
                                child:
                                    Text('Map only available on web platform')),
                      ),
                    ),

                  // City list section (always visible)
                  Expanded(
                    flex: _isMapVisible ? 1 : 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header for city locations
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              'City Locations',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),

                          // Use Expanded to contain the ListView
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate how many cards can fit based on screen width
                                final cardWidth =
                                    constraints.maxWidth < 600 ? 150.0 : 180.0; // Wider cards

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: CitiesData.cities.length,
                                  itemBuilder: (context, index) {
                                    final city = CitiesData.cities[index];
                                    final isSelected =
                                        _selectedCity?.id == city.id;

                                    return Container(
                                      width: cardWidth,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 8),
                                      child: Card(
                                        elevation: isSelected ? 3 : 1,
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        color: isSelected
                                            ? Colors.green.withOpacity(0.1)
                                            : null, // Use green for selected card
                                        child: InkWell(
                                          onTap: () => _focusOnCity(city),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            // Make content stretch to fill width
                                            children: [
                                              // City image - make it taller to fill more space
                                              Expanded(
                                                flex: 8, // Increased from 7 to make images taller
                                                // Give the image more space in the card
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  // Ensure stack fills available space
                                                  children: [
                                                    // Image - expanded to fill available space
                                                    city.images.isNotEmpty
                                                        ? Image.asset(
                                                            city.images.first,
                                                            fit: BoxFit.cover,
                                                            filterQuality: FilterQuality.high,
                                                          )
                                                        : Container(
                                                            color: Colors
                                                                .grey[300]),
                                                    // Name overlay with gradient background
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4),
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              city.name,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              city.arabicName,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 11,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Positioned(
                                                        top: 3,
                                                        right: 3,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.green,
                                                            // Use green for consistency
                                                          ),
                                                          child: const Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 10,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              // Explore button
                                              Expanded(
                                                flex: 2,
                                                // Smaller proportion for the button area
                                                child: Material(
                                                  color: Colors.green,
                                                  // Use green for consistency
                                                  child: InkWell(
                                                    onTap: () =>
                                                        _navigateToCityDetails(
                                                            city),
                                                    child: const Center(
                                                      child: Text(
                                                        'EXPLORE',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isMapVisible) {
            // Reset map view when map is visible
            _resetMapView();
          } else {
            // Force navigation to main screen (index 0 - Explore)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          }
        },
        tooltip: _isMapVisible ? 'Reset map view' : 'Go to home',
        child: Icon(_isMapVisible ? Icons.my_location : Icons.home),
        backgroundColor: Colors.green, // Use consistent green colorcolor
      ),
    );
  }
}
