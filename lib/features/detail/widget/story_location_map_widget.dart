import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/provider/setting_provider.dart';
import 'package:storyqito_app/features/map/util/map_style.dart';

class StoryLocationMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final BorderRadius? borderRadius;
  final bool controlsEnabled;

  const StoryLocationMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 200.0,
    this.borderRadius,
    this.controlsEnabled = true,
  });

  @override
  State<StoryLocationMapWidget> createState() => _StoryLocationMapWidgetState();
}

class _StoryLocationMapWidgetState extends State<StoryLocationMapWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.select<SettingProvider, bool>(
      (provider) => provider.setting?.isDark == true,
    );

    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId("story-location"),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(title: "Story Location"),
      ),
    };

    return FutureBuilder(
      future: Future.delayed(
        const Duration(milliseconds: 600),
      ).then((_) => mounted),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: widget.height,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          height: widget.height,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
          child: GoogleMap(
            style: isDark ? customStyleDark : customStyleLight,
            mapType: MapType.normal,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 11.0,
            ),
            myLocationButtonEnabled: widget.controlsEnabled,
            zoomControlsEnabled: widget.controlsEnabled,
            zoomGesturesEnabled: true,
          ),
        );
      },
    );
  }
}
