import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';

import 'dart:math' as math;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final LatLng _currentPosition = const LatLng(16.5449, 81.5212);
  bool _isLoading = true;
  final List<PersonData> _people = [];
  bool _showFarmers = true;
  bool _showVets = true;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  final List<String> _farmerNames = [
    "Rajesh Patel",
    "Suresh Kumar",
    "Ramesh Singh",
    "Arjun Reddy",
    "Vijay Sharma"
  ];

  final List<String> _vetNames = [
    "Dr. Aditya Shah",
    "Dr. Priya Desai",
    "Dr. Vikram Malhotra",
    "Dr. Neha Kapoor"
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _generateDummyData();
    _initializeMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      await _checkLocationPermission();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      bool? result = await DirectCaller().makePhoneCall(phoneNumber);
      if (result != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to make the call. Please try again.")),
        );
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied. Cannot make a call.")),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Permission permanently denied. Enable in settings."),
        ),
      );
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  void _generateDummyData() {
    // Generate farmers
    for (int i = 0; i < 5; i++) {
      _people.add(
        PersonData(
          id: "F$i",
          name: _farmerNames[i],
          type: PersonType.farmer,
          phone: "630364${2290 + i}",
          position: _getRandomLocationWithin30Km(),
        ),
      );
    }

    // Generate vets
    for (int i = 0; i < 4; i++) {
      _people.add(
        PersonData(
          id: "V$i",
          name: _vetNames[i],
          type: PersonType.veterinary,
          phone: "994941${2290 + i}",
          position: _getRandomLocationWithin30Km(),
        ),
      );
    }
  }

  LatLng _getRandomLocationWithin30Km() {
    const double earthRadius = 6371;
    const double maxDistance = 30;

    final double lat1 = _currentPosition.latitude * math.pi / 180;
    final double lon1 = _currentPosition.longitude * math.pi / 180;
    final double distance = math.Random().nextDouble() * maxDistance;
    final double bearing = math.Random().nextDouble() * 2 * math.pi;

    final double latRad = math.asin(math.sin(lat1) *
            math.cos(distance / earthRadius) +
        math.cos(lat1) * math.sin(distance / earthRadius) * math.cos(bearing));

    final double lonRad = lon1 +
        math.atan2(
            math.sin(bearing) *
                math.sin(distance / earthRadius) *
                math.cos(lat1),
            math.cos(distance / earthRadius) -
                math.sin(lat1) * math.sin(latRad));

    return LatLng(latRad * 180 / math.pi, lonRad * 180 / math.pi);
  }

  void _initializeMarkers() {
    _markers = {};
    _circles = {};

    // Add 30km radius circle
    _circles.add(
      Circle(
        circleId: const CircleId('radius_30km'),
        center: _currentPosition,
        radius: 30000,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue.withOpacity(0.7),
        strokeWidth: 2,
      ),
    );

    // Add current location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'My Location'),
      ),
    );

    // Add people markers
    for (var person in _people) {
      if (person.type == PersonType.farmer && !_showFarmers) continue;
      if (person.type == PersonType.veterinary && !_showVets) continue;

      _markers.add(
        Marker(
          markerId: MarkerId(person.id),
          position: person.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              person.type == PersonType.farmer
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed),
          onTap: () {
            _showSimpleInfoWindow(person);
          },
        ),
      );
    }

    setState(() {});
  }

  void _showSimpleInfoWindow(PersonData person) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                person.type == PersonType.farmer
                    ? Icons.agriculture
                    : Icons.local_hospital,
                color: person.type == PersonType.farmer
                    ? Colors.green
                    : Colors.red,
                size: 36,
              ),
              title: Text(
                person.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                person.type == PersonType.farmer ? 'Farmer' : 'Veterinarian',
                style: TextStyle(
                  color: person.type == PersonType.farmer
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: Text(person.phone),
              onTap: () {
                // Handle phone number tap
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Calling ${person.name}...")),
                );
                _makePhoneCall(context, "8125150264");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmers & Vets Map"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 11,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              circles: _circles,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
            ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentPosition, 11),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filter Markers"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Show Farmers"),
              value: _showFarmers,
              onChanged: (value) {
                setState(() {
                  _showFarmers = value;
                  _initializeMarkers();
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text("Show Veterinarians"),
              value: _showVets,
              onChanged: (value) {
                setState(() {
                  _showVets = value;
                  _initializeMarkers();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Reset"),
            onPressed: () {
              setState(() {
                _showFarmers = true;
                _showVets = true;
                _initializeMarkers();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

enum PersonType { farmer, veterinary }

class PersonData {
  final String id;
  final String name;
  final PersonType type;
  final String phone;
  final LatLng position;

  PersonData({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.position,
  });
}
