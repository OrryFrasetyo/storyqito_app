import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBounds {
  final double? north;
  final double? south;
  final double? east;
  final double? west;

  MapBounds({this.north, this.south, this.east, this.west});

  factory MapBounds.fromLatLngList(List<LatLng> locations) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in locations) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return MapBounds(north: x1, south: x0, east: y1, west: y0);
  }

  LatLngBounds toBounds() {
    if (north == null || south == null || east == null || west == null) {
      return LatLngBounds(
        northeast: const LatLng(85, 180), 
        southwest: const LatLng(-85, -180), 
      );
    }

    return LatLngBounds(
      northeast: LatLng(north!, east!),
      southwest: LatLng(south!, west!),
    );
  }
}