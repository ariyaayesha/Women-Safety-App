// sos_screen.dart
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool sosActive = false;
  String locationText = "";

  void _handleSOS(bool val) async {
    setState(() {
      sosActive = val;
    });

    if (val) {
      try {
        Position position = await LocationService.getCurrentLocation();
        setState(() {
          locationText =
              "Lat: \${position.latitude}, Lng: \${position.longitude}";
        });

        final uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': DateTime.now()
          }
        });
      } catch (e) {
        setState(() {
          locationText = "Location access failed: \$e";
        });
      }
    } else {
      setState(() {
        locationText = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("SOS is \${sosActive ? 'Active' : 'Inactive'}"),
          Switch(
            value: sosActive,
            onChanged: _handleSOS,
          ),
          SizedBox(height: 20),
          if (locationText.isNotEmpty) Text(locationText),
        ],
      ),
    );
  }
}
