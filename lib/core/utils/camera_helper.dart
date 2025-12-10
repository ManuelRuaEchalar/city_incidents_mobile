import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        // *** Ajustes para calidad intermedia baja y tamaño menor ***
        imageQuality: 50, // Calidad de compresión JPEG (50 es media-baja)
        maxWidth: 1280, // Ancho máximo (por ejemplo, 1280p)
        maxHeight: 720, // Alto máximo (por ejemplo, 720p)
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      // Es una buena práctica usar print() para debugging y lanzar una excepción para manejo de errores
      print('Error al tomar la foto: $e');
      throw Exception('Error al tomar la foto: $e');
    }
  }
}
