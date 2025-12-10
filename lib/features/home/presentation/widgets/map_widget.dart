import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/map_controller_helper.dart';
import '../../data/models/incident_model.dart';
import '../../data/repositories/incident_repository.dart';
import 'incident_dialog.dart';

class MapWidget extends StatefulWidget {
  final List<IncidentModel> incidents;

  const MapWidget({super.key, required this.incidents});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng _currentPosition = const LatLng(-19.0464, -65.2590);
  bool _isLoadingLocation = true;
  final IncidentRepository _repository = IncidentRepository();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Verificar si hay una ubicación objetivo para centrar después de que el mapa esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MapControllerHelper.checkAndMoveToTarget();
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoadingLocation = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoadingLocation = false);
      return;
    }

    try {
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null && mounted) {
        setState(() {
          _currentPosition = LatLng(
            lastPosition.latitude,
            lastPosition.longitude,
          );
        });
        // Solo mover si no hay target pendiente
        if (MapControllerHelper.targetLatitude == null) {
          MapControllerHelper.moveMap(
            _currentPosition.latitude,
            _currentPosition.longitude,
            zoom: 15.0,
          );
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        // Solo mover si no hay target pendiente
        if (MapControllerHelper.targetLatitude == null) {
          MapControllerHelper.moveMap(
            _currentPosition.latitude,
            _currentPosition.longitude,
            zoom: 16.0,
          );
        }
      }
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  String _getCategoryIcon(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'assets/icons/local_via.svg';
      case 2:
        return 'assets/icons/local_semaforo.svg';
      case 3:
        return 'assets/icons/local_luz.svg';
      case 4:
        return 'assets/icons/local_basura.svg';
      default:
        return 'assets/icons/local_edificio.svg';
    }
  }

  Future<void> _showIncidentDetail(int incidentId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final incidentDetail = await _repository.getIncidentById(incidentId);

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => IncidentDialog(
            incident: IncidentModel(
              incidentId: incidentDetail.incidentId,
              categoryId: incidentDetail.categoryId,
              statusId: incidentDetail.statusId,
              cityId: incidentDetail.cityId,
              latitude: incidentDetail.latitude,
              longitude: incidentDetail.longitude,
              description: incidentDetail.description,
              photoUrl: incidentDetail.photoUrl,
              addressRef: incidentDetail.addressRef,
              createdAt: incidentDetail.createdAt,
              username: '',
            ),
            category: incidentDetail.category,
            status: incidentDetail.status,
            city: incidentDetail.city,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: MapControllerHelper.mapController,
          options: MapOptions(
            initialCenter: _currentPosition,
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.incident_reporter',
            ),
            MarkerLayer(
              markers: [
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
                ...widget.incidents.map((incident) {
                  return Marker(
                    point: LatLng(incident.latitude, incident.longitude),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showIncidentDetail(incident.incidentId),
                      child: SvgPicture.asset(
                        _getCategoryIcon(incident.categoryId),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
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
                  Text("Ubicando...", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
