import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ubicación de usuario'),
      ),
      body: OnlyMap()
    );
  }
}

class OnlyMap extends StatefulWidget {
  @override
  _OnlyMapState createState() => _OnlyMapState();
}

class _OnlyMapState extends State<OnlyMap> {

  final double _deftZoom = 16;

  MapController _mapController = MapController();

  Position _currentPosition = new Position(
    latitude: 6.249464209928846, // Valor por defecto para la latitud
    longitude: -75.58378045275181, // Valor por defecto para la longitud
    timestamp: DateTime.now(), // Valor por defecto para la fecha y hora
    accuracy: 0.0, // Valor por defecto para la precisión
    altitude: 1.2, // Valor por defecto para la altitud
    altitudeAccuracy: 1.2,
    heading: 2.2, // Valor por defecto para la dirección
    headingAccuracy: 2.2,
    speed: 0.0, // Valor por defecto para la velocidad
    speedAccuracy: 0.0, // Valor por defecto para la precisión de la velocidad
  );

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

      _mapController.move(LatLng( _currentPosition.latitude , _currentPosition.longitude ), _deftZoom);
    })
    .catchError((e) {
      debugPrint(e);
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng( _currentPosition.latitude , _currentPosition.longitude ), // Center the map over London
        initialZoom: _deftZoom,
      ),
      children: [
        TileLayer( // Display map tiles from any source
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // And many more recommended properties!
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(_currentPosition.latitude, _currentPosition.longitude), // Coordenadas del marcador
              child: const Tooltip(
                message: "Ubicación actual",
                child: Icon(Icons.place, color: Colors.redAccent, size: 30),
              )
            )
          ],
        ),
        const RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
            ),
            // Also add images...
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: 
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:
            FloatingActionButton(
              onPressed: _getCurrentPosition,
              tooltip: "Agregar hubicacion actual",
              // child: Icon(Icons.add_location, color: Colors.white, size: 30),
              child: Icon(Icons.my_location, color: Colors.white, size: 30),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        )
      ],
    ); 
  }
}

/*
class OnlyMap extends StatelessWidget{

  

  

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(6.249464209928846, -75.58378045275181), // Center the map over London
        initialZoom: 16,
      ),
      children: [
        TileLayer( // Display map tiles from any source
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // And many more recommended properties!
        ),
        const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(6.249464209928846, -75.58378045275181), // Coordenadas del marcador
              child: Tooltip(
                message: "Ubicación actual",
                child: Icon(Icons.place, color: Colors.redAccent, size: 30),
              )
            )
          ],
        ),
        RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
            ),
            // Also add images...
          ],
        ),
      ],
    ); 
  }
}
*/