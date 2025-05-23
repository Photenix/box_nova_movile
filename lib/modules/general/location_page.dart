import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget{
  const LocationPage({super.key});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  // String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {   
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.high )
    .then((Position position) {
      setState(() => _currentPosition = position);
      print(_currentPosition);
    })
    .catchError((e) {
      debugPrint(e);
    });
  }



  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text("Location Page")),
       body: SafeArea(
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text('LAT: '),
               const Text('LNG: '),
               const Text('ADDRESS: '),  
               const SizedBox(height: 32), 
               ElevatedButton(
                 onPressed: _getCurrentPosition,  
                 child: const Text("Get Current Location"),
               )
             ],
           ),
         ),
       ),
    );
  }
}

