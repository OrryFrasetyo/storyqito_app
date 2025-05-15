import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';

class LocationMapControlsWidget extends StatelessWidget {
  final LatLng location;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onClear;
  final bool isLoading;

  const LocationMapControlsWidget({
    super.key,
    required this.location,
    required this.onUseCurrentLocation,
    required this.onClear,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${location.latitude.toStringAsFixed(6)}, "
            "${location.longitude.toStringAsFixed(6)}",
            style: TextStyle(
              fontSize: 12.0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        TextButton.icon(
          onPressed: isLoading ? null : onUseCurrentLocation,
          icon: const Icon(Icons.my_location, size: 18.0),
          label: Text(AppLocalizations.of(context)!.use_current_location),
        ),

        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.clear, size: 18.0),
          label: Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }
}
