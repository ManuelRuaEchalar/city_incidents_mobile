import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../features/home/presentation/pages/home_page.dart';

class MapControllerHelper {
  static MapController? _mapController;

  static double? targetLatitude;
  static double? targetLongitude;

  static MapController get mapController {
    _mapController ??= MapController();
    return _mapController!;
  }

  /// Reinicializa el controller (útil cuando se reconstruye el widget del mapa)
  static void resetController() {
    _mapController = MapController();
  }

  static void moveMap(double lat, double lng, {double zoom = 17.0}) {
    try {
      mapController.move(LatLng(lat, lng), zoom);
    } catch (e) {
      debugPrint("Error moviendo el mapa: $e");
    }
  }

  static void clearTarget() {
    targetLatitude = null;
    targetLongitude = null;
  }

  static void navigateToLocation(BuildContext context, double lat, double lng) {
    targetLatitude = lat;
    targetLongitude = lng;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  /// Comprueba si hay coordenadas pendientes y mueve el mapa
  static void checkAndMoveToTarget() {
    if (targetLatitude != null && targetLongitude != null) {
      // Usar delay para asegurar que el mapa esté listo
      Future.delayed(const Duration(milliseconds: 300), () {
        moveMap(targetLatitude!, targetLongitude!, zoom: 17.0);
        clearTarget();
      });
    }
  }
}
