import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyqito_app/core/data/network/responses/geocode_response.dart';
import 'package:storyqito_app/core/utils/maps_environment.dart';

class MapsApiService {
  static const String _baseUrl = "geocode.maps.co";
  static const String _reversePath = '/reverse';
  static String get _apiKey => MapsEnvironment.geocodeMapsApiKey;

  final http.Client _httpClient;

  MapsApiService({required http.Client httpClient}) : _httpClient = httpClient;

  Future<GeocodeResponse> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    final queryParameters = {
      "lat": lat.toString(),
      "lon": lon.toString(),
      "api_key": _apiKey,
    };

    final uri = Uri.https(_baseUrl, _reversePath, queryParameters);

    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return GeocodeResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to get address: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to connect to geocode.maps.co API: $e");
    }
  }
}
