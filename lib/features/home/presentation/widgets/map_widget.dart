import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/incident_model.dart'; // Asegúrate que esta ruta sea correcta en tu proyecto

class MapWidget extends StatefulWidget {
  final List<IncidentModel> incidents;

  const MapWidget({super.key, required this.incidents});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  // Coordenadas por defecto (Sucre) en caso de que todo falle
  LatLng _currentPosition = const LatLng(-19.0464, -65.2590);
  bool _isLoadingLocation = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Servicios de ubicación deshabilitados.');
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    // 2. Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Permiso denegado.');
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Permiso denegado permanentemente.');
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    try {
      // 3. INTENTO RÁPIDO: Obtener la última ubicación conocida
      // Esto sirve para mostrar algo rápido mientras el GPS preciso "calienta".
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null && mounted) {
        // Actualizamos temporalmente con la última posición conocida
        // pero NO quitamos el loading todavía, esperamos la precisa.
        setState(() {
          _currentPosition = LatLng(
            lastPosition.latitude,
            lastPosition.longitude,
          );
        });
        // Movemos el mapa preliminarmente
        _mapController.move(_currentPosition, 15.0);
      }

      // 4. INTENTO PRECISO: Forzar uso de GPS (High Accuracy)
      // Esto es lo que soluciona el problema de que te ubique en La Paz (antena)
      // en lugar de Sucre (tú).
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.high, // <--- CLAVE: Pide GPS satelital
        timeLimit: const Duration(seconds: 15), // Damos tiempo al satélite
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        // Movemos el mapa a la ubicación real confirmada
        _mapController.move(_currentPosition, 16.0);
      }
    } catch (e) {
      debugPrint('Error obteniendo ubicación precisa: $e');
      // Si falla el GPS preciso (ej. estás bajo techo),
      // nos quedamos con la última conocida o la por defecto (Sucre).
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition,
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.incident_reporter',
            ),
            // Solo mostramos marcadores si ya terminó de cargar O si tenemos una posición válida
            MarkerLayer(
              markers: [
                // Marcador de MI ubicación (Azul)
                Marker(
                  point: _currentPosition,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 40,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                  ),
                ),
                // Marcadores de los INCIDENTES (Rojos)
                ...widget.incidents.map((incident) {
                  return Marker(
                    point: LatLng(incident.latitude, incident.longitude),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        // Indicador de carga superpuesto
        if (_isLoadingLocation)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black26),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Precisando ubicación...",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
