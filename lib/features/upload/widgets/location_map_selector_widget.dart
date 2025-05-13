import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/address_provider.dart';
import 'package:storyqito_app/features/map/util/map_style.dart';

class LocationMapSelectorWidget extends StatelessWidget {
  const LocationMapSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final uploadProvider = context.watch<AddNewStoryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              localizations.location,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            Switch(
              value: uploadProvider.isLocationAttached,
              onChanged: (value) {
                uploadProvider.toggleLocationAttached(value);
              },
            ),
          ],
        ),
        if (uploadProvider.isLocationAttached) ...[
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: uploadProvider.isLocationAttached ? 1.0 : 0.0,
            child: Container(
              height: 250.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  GoogleMap(
                    style: isDark ? customStyleDark : customStyleLight,
                    mapType: MapType.normal,
                    markers: {
                      if (uploadProvider.attachedLocation != null)
                        Marker(
                          markerId: const MarkerId("story_location"),
                          position: uploadProvider.attachedLocation!,
                          draggable: true,
                          onDragEnd: (newPosition) {
                            uploadProvider.setAttachedLocation(newPosition);
                          },
                          infoWindow: InfoWindow(
                            snippet:
                                context
                                    .watch<AddressProvider>()
                                    .formattedAddress ??
                                AppLocalizations.of(
                                  context,
                                )!.address_not_available,
                          ),
                        ),
                    },
                    initialCameraPosition: CameraPosition(
                      target:
                          uploadProvider.attachedLocation ??
                          const LatLng(-2.014380, 118.152180),
                      zoom: uploadProvider.attachedLocation != null ? 12 : 4,
                    ),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    onTap: (position) {
                      uploadProvider.setAttachedLocation(position);
            
                      context.read<AddressProvider>().getAddressFromCoordinates(
                        position.latitude,
                        position.longitude,
                      );
                    },
                  ),
            
                  if (uploadProvider.attachedLocation == null)
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 40,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.tap_to_select_location,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (uploadProvider.attachedLocation != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${uploadProvider.attachedLocation!.latitude.toStringAsFixed(6)}, "
                    "${uploadProvider.attachedLocation!.longitude.toStringAsFixed(6)}",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                TextButton.icon(
                  onPressed: () {
                    uploadProvider.setAttachedLocation(null);
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  label: Text(AppLocalizations.of(context)!.cancel),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}
