import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onSOSPressed() async {
    // Placeholder for sending SMS via an API or backend function
    final contacts = await firebaseService.getEmergencyContacts();
    print('Sending SOS to: $contacts');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SOS alert sent to emergency contacts!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [
          Expanded(
            child: _currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) => mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId("current_location"),
                        position: _currentPosition!,
                        infoWindow: InfoWindow(title: "You are here"),
                      )
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onSOSPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text('Send SOS'),
            ),
          ),
        ],
      ),
    );
  }
}
