import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/provider/map/map_provider.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
import 'package:storyqito_app/features/map/util/map_style.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();
    final isDark = context.watch<SettingProvider>().setting?.isDark == true;

    return context.mounted
        ? GoogleMap(
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
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
        )
        : const SizedBox.shrink();
  }
}
