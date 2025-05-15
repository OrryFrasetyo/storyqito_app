// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyqito_app/core/data/network/responses/geocode_address.dart';

part 'geocode_response.freezed.dart';
part 'geocode_response.g.dart';

@freezed
abstract class GeocodeResponse with _$GeocodeResponse {
  const factory GeocodeResponse({
    @JsonKey(name: 'place_id') required int placeId,
    required String licence,
    @JsonKey(name: 'osm_type') required String osmType,
    @JsonKey(name: 'osm_id') required int osmId,
    required String lat,
    required String lon,
    @JsonKey(name: 'display_name') required String displayName,
    required GeocodeAddress address,
    required List<String> boundingbox,
  }) = _GeocodeResponse;

  factory GeocodeResponse.fromJson(Map<String, dynamic> json) =>
      _$GeocodeResponseFromJson(json);
}