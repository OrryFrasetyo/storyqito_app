import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UploadMapControllerProvider extends ChangeNotifier {
  GoogleMapController? _mapController;

  final Completer<GoogleMapController> _controllerCompleter =
      Completer<GoogleMapController>();

  GoogleMapController? get mapController => _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (!_controllerCompleter.isCompleted) {
      _controllerCompleter.complete(controller);
    }
    notifyListeners();
  }

  void disposeController() {
    _mapController?.dispose();
    _mapController = null;
    notifyListeners();
  }

  Future<void> animateCamera(CameraPosition position) async {
    try {
      final controller = await _controllerCompleter.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(position));
    } catch (e) {
      debugPrint("Error animate camera: $e");
    }
  }
}
