import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/network/responses/geocode_response.dart';
import 'package:storyqito_app/core/data/network/service/maps_api_service.dart';

class MapsRepository {
  final MapsApiService _mapsApiService;

  MapsRepository(this._mapsApiService);

  Future<GeocodeResponse?> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _mapsApiService.getAddressFromCoordinates(
        lat,
        lon,
      );
      return response;
    } catch (e) {
      debugPrint("Error getting address from coordinates: $e");
      return null;
    }
  }

  Future<String?> getFormattedAddress(double lat, double lon) async {
    try {
      final response = await _mapsApiService.getAddressFromCoordinates(
        lat,
        lon,
      );
      return response.displayName;
    } catch (e) {
      debugPrint("Error getting formatted address: $e");
      return null;
    }
  }

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    try {
      throw UnimplementedError(
        "Forward geocoding not implemented for geocode.maps.co API",
      );
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
      return null;
    }
  }
}
