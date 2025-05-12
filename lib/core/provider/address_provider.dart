import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/network/responses/geocode_response.dart';
import 'package:storyqito_app/core/data/repository/maps_repository.dart';

enum AddressLoadState { initial, loading, loaded, error }

class AddressProvider extends ChangeNotifier {
  final MapsRepository _mapsRepository;

  AddressLoadState _state = AddressLoadState.initial;
  String? _formattedAddress;
  GeocodeResponse? _detailedAddress;
  String? _errorMessage;

  AddressProvider(this._mapsRepository);

  AddressLoadState get state => _state;

  String? get formattedAddress => _formattedAddress;

  GeocodeResponse? get detailedAddress => _detailedAddress;

  String? get errorMessage => _errorMessage;

  Future<void> getAddressFromCoordinates(double lat, double lon) async {
    _state = AddressLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mapsRepository.getAddressFromCoordinates(
        lat,
        lon,
      );
      if (response != null) {
        _formattedAddress = response.displayName;
        _detailedAddress = response;
        _state = AddressLoadState.loaded;
      } else {
        throw Exception("No address data returned");
      }
    } catch (e) {
      _state = AddressLoadState.error;
      _errorMessage = "Failed to load address: $e";
    }

    notifyListeners();
  }

  void reset() {
    _state = AddressLoadState.initial;
    _formattedAddress = null;
    _detailedAddress = null;
    _errorMessage = null;
    notifyListeners();
  }
}