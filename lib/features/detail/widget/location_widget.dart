import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/responses/list_story.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/address_provider.dart';
import 'package:storyqito_app/features/detail/widget/address_widget.dart';
import 'package:storyqito_app/features/detail/widget/story_location_map_widget.dart';

class LocationWidget extends StatefulWidget {
  final ListStory listStory;
  final bool mapControlsEnabled;
  final String mapKeyPrefix;

  const LocationWidget({
    super.key,
    required this.listStory,
    this.mapControlsEnabled = true,
    this.mapKeyPrefix = "detail",
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  bool _requestAddress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_requestAddress) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddressProvider>().getAddressFromCoordinates(
          widget.listStory.lat!,
          widget.listStory.lon!,
        );
      });
      _requestAddress = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16.0),

        AddressWidget(
          latitude: widget.listStory.lat!,
          longitude: widget.listStory.lon!,
          storyId: widget.listStory.id,
        ),

        const SizedBox(height: 16.0),

        StoryLocationMapWidget(
          key: ValueKey(
            "${widget.mapKeyPrefix}-location-map-${widget.listStory.id}",
          ),
          latitude: widget.listStory.lat!,
          longitude: widget.listStory.lon!,
          height: 400.0,
          controlsEnabled: widget.mapControlsEnabled,
          title: widget.listStory.name,
          location:
              context.watch<AddressProvider>().formattedAddress ??
              AppLocalizations.of(context)!.address_not_available,
        ),
      ],
    );
  }
}
