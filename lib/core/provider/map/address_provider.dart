import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/network/static/address_load_state.dart';
import 'package:storyqito_app/core/data/repository/maps_repository.dart';

class AddressProvider extends ChangeNotifier {
  final MapsRepository _mapsRepository;

  AddressProvider(this._mapsRepository);

  AddressLoadState _state = const AddressLoadState.initial();
  AddressLoadState get state => _state;

  Future<void> getAddressFromCoordinates(double lat, double lon) async {
    _state = AddressLoadState.loading();
    notifyListeners();

    try {
      final response = await _mapsRepository.getAddressFromCoordinates(
        lat,                  
        lon,
      );
      if (response != null) {
        _state = AddressLoadState.loaded(response.displayName);
      } else {
        _state = AddressLoadState.error("No address data returned");
      }
    } catch (e) {
      _state = AddressLoadState.error(e.toString());
    }

    notifyListeners();
  }

  void reset() {
    _state = AddressLoadState.initial();
    notifyListeners();
  }
}
