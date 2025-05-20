import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/static/address_load_state.dart';
import 'package:storyqito_app/core/provider/map/address_provider.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/upload/upload_map_controller_provider.dart';
import 'package:storyqito_app/features/map/util/map_style.dart';

class BuildGoogleMapWidget extends StatelessWidget {
  const BuildGoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();

    return context.mounted
        ? GoogleMap(
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          style: isDark ? customStyleDark : customStyleLight,
          mapType: MapType.normal,
          markers: {
            if (addNewStoryProvider.attachedLocation != null)
              Marker(
                markerId: const MarkerId("story_location"),
                position: addNewStoryProvider.attachedLocation!,
                draggable: true,
                onDragEnd: (newPosition) {
                  addNewStoryProvider.setAttachedLocation(newPosition);

                  context.read<AddressProvider>().getAddressFromCoordinates(
                    newPosition.latitude,
                    newPosition.longitude,
                  );
                },
                infoWindow: InfoWindow(
                  snippet: context
                      .watch<AddressProvider>()
                      .state
                      .getAddressOrFallback(context),
                ),
              ),
          },

          initialCameraPosition: CameraPosition(
            target:
                addNewStoryProvider.attachedLocation ??
                const LatLng(-2.014370, 118.152170),
            zoom: addNewStoryProvider.attachedLocation != null ? 15 : 4,
          ),

          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            context.read<UploadMapControllerProvider>().setMapController(
              controller,
            );
          },
          onTap: (position) {
            addNewStoryProvider.setAttachedLocation(position);

            context.read<AddressProvider>().getAddressFromCoordinates(
              position.latitude,
              position.longitude,
            );
          },
        )
        : const SizedBox.shrink();
  }
}
