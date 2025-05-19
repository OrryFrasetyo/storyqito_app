import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
import 'package:storyqito_app/features/map/util/map_style.dart';

class StoryLocationMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final bool controlsEnabled;
  final String title;
  final String location;
  final BorderRadius? borderRadius;

  const StoryLocationMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 200.0,
    this.controlsEnabled = true,
    required this.title,
    required this.location,
    this.borderRadius,
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
        infoWindow: InfoWindow(title: widget.title, snippet: widget.location),
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
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          height: widget.height,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
          ),
          child: Listener(
            key: const Key("map-listener"),
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child:
                context.mounted
                    ? GoogleMap(
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      style: isDark ? customStyleDark : customStyleLight,
                      mapType: MapType.normal,
                      markers: markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 11.0,
                      ),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: widget.controlsEnabled,
                      zoomGesturesEnabled: true,
                    )
                    : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
