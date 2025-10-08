import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// Data model for places found via the Overpass API
class Place {
  final double lat;
  final double lon;
  final String name;

  Place({required this.lat, required this.lon, required this.name});
}

class NearbyCentersScreen extends StatefulWidget {
  const NearbyCentersScreen({super.key});

  @override
  _NearbyCentersScreenState createState() => _NearbyCentersScreenState();
}

class _NearbyCentersScreenState extends State<NearbyCentersScreen> {
  LatLng? _userLocation;
  List<Place> _nearbyCenters = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetchCenters();
  }

  // 1. Get user's location
  Future<void> _determinePositionAndFetchCenters() async {
    // Standard location permission handling...
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location permission denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Location permissions are permanently denied.';
      });
      return;
    }

    // Fetch position and then search for centers
    try {
      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
      await _fetchNearbyHospitals();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not get current location.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 2. Fetch data for hospitals from Overpass API
  Future<void> _fetchNearbyHospitals() async {
    if (_userLocation == null) return;

    const radiusInMeters = 15000; // 15 km search radius
    // Query for all hospitals
    final String query = """
      [out:json][timeout:25];
      (
        node["amenity"="hospital"](around:$radiusInMeters,${_userLocation!.latitude},${_userLocation!.longitude});
        way["amenity"="hospital"](around:$radiusInMeters,${_userLocation!.latitude},${_userLocation!.longitude});
        relation["amenity"="hospital"](around:$radiusInMeters,${_userLocation!.latitude},${_userLocation!.longitude});
      );
      out center;
    """;

    try {
      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: {'data': query},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Place> places = [];
        for (final element in data['elements']) {
          String name = element['tags']?['name'] ?? 'Unnamed Hospital';
          double? lat, lon;

          if (element['type'] == 'node') {
            lat = element['lat'];
            lon = element['lon'];
          } else if (element['center'] != null) {
            lat = element['center']['lat'];
            lon = element['center']['lon'];
          }

          if (lat != null && lon != null) {
            places.add(Place(lat: lat, lon: lon, name: name));
          }
        }
        if (!mounted) return;
        setState(() {
          _nearbyCenters = places;
          if (places.isEmpty) {
            _errorMessage = "No hospitals found within 15km.";
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to fetch data. Check your network.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The main screen content
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (_errorMessage.isNotEmpty && _nearbyCenters.isEmpty) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    } else {
      // The split-screen UI
      bodyContent = Column(
        children: [
          // HEADING
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Nearby Hospitals",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // MAP VIEW (Top Half)
          Expanded(
            flex: 1, // Takes up 50% of the space
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _userLocation ??
                    const LatLng(17.3850, 78.4867), // Default to Hyderabad
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    if (_userLocation != null)
                      Marker(
                        point: _userLocation!,
                        width: 80,
                        height: 80,
                        child: const Icon(Icons.my_location,
                            color: Colors.blueAccent, size: 40),
                      ),
                    ..._nearbyCenters.map((place) => Marker(
                          point: LatLng(place.lat, place.lon),
                          width: 80,
                          height: 80,
                          child: Tooltip(
                            message: place.name,
                            child: const Icon(Icons.location_pin,
                                color: Color(0xFFE91E63), size: 40),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          // LIST VIEW (Bottom Half)
          Expanded(
            flex: 1, // Takes up 50% of the space
            child: ListView.builder(
              itemCount: _nearbyCenters.length,
              itemBuilder: (context, index) {
                final place = _nearbyCenters[index];
                return Card(
                  color: Colors.white.withOpacity(0.1),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.local_hospital,
                        color: Color(0xFF00BCD4)),
                    title: Text(place.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Lat: ${place.lat.toStringAsFixed(4)}, Lon: ${place.lon.toStringAsFixed(4)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Scaffold with themed background and bottom navigation
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Important for gradient to show through
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A3E),
              Color(0xFF311B92),
              Color(0xFF4A148C),
            ],
          ),
        ),
        child: SafeArea(child: bodyContent),
      ),
      // NOTE: Your home.dart file is responsible for showing the actual bottom navigation bar.
      // This screen is just the content that will be displayed *above* it.
    );
  }
}
