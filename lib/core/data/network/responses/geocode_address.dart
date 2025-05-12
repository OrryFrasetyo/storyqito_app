import 'package:freezed_annotation/freezed_annotation.dart';

part 'geocode_address.freezed.dart';
part 'geocode_address.g.dart';

@freezed
abstract class GeocodeAddress with _$GeocodeAddress {
  const factory GeocodeAddress({
    String? amenity,
    String? road,
    String? village,
    @JsonKey(name: 'city_district') String? cityDistrict,
    String? city,
    String? state,
    @JsonKey(name: 'ISO3166-2-lvl4') String? isoLvl4,
    String? region,
    @JsonKey(name: 'ISO3166-2-lvl3') String? isoLvl3,
    String? postcode,
    String? country,
    @JsonKey(name: 'country_code') String? countryCode,
  }) = _GeocodeAddress;

  factory GeocodeAddress.fromJson(Map<String, dynamic> json) =>
      _$GeocodeAddressFromJson(json);
}