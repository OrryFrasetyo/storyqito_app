import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/provider/map_provider.dart';
import 'package:storyqito_app/core/provider/setting_provider.dart';
import 'package:storyqito_app/features/map/util/map_style.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingProvider>().setting?.isDark == true;
    final mapProvider = context.watch<MapProvider>();

    return GoogleMap(
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      style: isDark ? customStyleDark : customStyleLight,
      mapType: mapProvider.selectedMapType,
      markers: mapProvider.markers,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-2.014390, 118.152190),
        zoom: 4,
      ),
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: mapProvider.onMapCreated,
    );
  }
}
