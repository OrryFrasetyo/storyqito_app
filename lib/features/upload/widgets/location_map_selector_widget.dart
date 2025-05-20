import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/map/address_provider.dart';
import 'package:storyqito_app/core/provider/upload/upload_location_loading_provider.dart';
import 'package:storyqito_app/core/provider/upload/upload_map_controller_provider.dart';
import 'package:storyqito_app/features/upload/util/get_localized_error_msg.dart';
import 'package:storyqito_app/features/upload/widgets/build_google_map_widget.dart';
import 'package:storyqito_app/features/upload/widgets/location_error_widget.dart';
import 'package:storyqito_app/features/upload/widgets/location_map_controls_widget.dart';
import 'package:storyqito_app/features/upload/widgets/location_map_placeholder_widget.dart';

class LocationMapSelectorWidget extends StatefulWidget {
  const LocationMapSelectorWidget({super.key});

  @override
  State<LocationMapSelectorWidget> createState() =>
      _LocationMapSelectorWidgetState();
}

class _LocationMapSelectorWidgetState extends State<LocationMapSelectorWidget> {
  

  Future<void> _getCurrentPosition(BuildContext context) async {
    final addNewStoryProvider = context.read<AddNewStoryProvider>();
    final locationLoadingProvider =
        context.read<UploadLocationLoadingProvider>();
    final uploadMapControllerProvider =
        context.read<UploadMapControllerProvider>();

    locationLoadingProvider.setIsLoading(true);
    locationLoadingProvider.setErrorMessage(null);

    try {
      final position = await _determinePosition(context);
      final latLng = LatLng(position.latitude, position.longitude);

      addNewStoryProvider.setAttachedLocation(latLng);

      if (context.mounted) {
        context.read<AddressProvider>().getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      if (context.mounted) {
        await uploadMapControllerProvider.animateCamera(
          CameraPosition(target: latLng, zoom: 15),
        );
      }
    } catch (e) {
      if (context.mounted) {
        locationLoadingProvider.setErrorMessage(
          getLocalizedErrorMsg(context, e.toString()),
        );
      }
    } finally {
      locationLoadingProvider.setIsLoading(false);
    }
  }

  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        return Future.error(
          AppLocalizations.of(context)!.location_services_disabled,
        );
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          return Future.error(
            AppLocalizations.of(context)!.location_permissions_denied,
          );
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        return Future.error(
          AppLocalizations.of(context)!.location_permissions_permanently_denied,
        );
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();
    final uploadLocationLoadingProvider =
        context.watch<UploadLocationLoadingProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (addNewStoryProvider.isLocationAttached &&
          addNewStoryProvider.attachedLocation == null &&
          !uploadLocationLoadingProvider.isLoading &&
          uploadLocationLoadingProvider.errorMessage == null) {
        _getCurrentPosition(context);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMapHeader(context, addNewStoryProvider),

        if (addNewStoryProvider.isLocationAttached) ...[
          const SizedBox(height: 16.0),

          _buildMapContainer(
            context,
            addNewStoryProvider,
            uploadLocationLoadingProvider,
          ),
          if (addNewStoryProvider.attachedLocation != null) ...[
            const SizedBox(height: 8.0),
            LocationMapControlsWidget(
              onUseCurrentLocation: () => _getCurrentPosition(context),
              onClear: () async {
                if (!context.mounted) return;

                final controllerProvider =
                    context.read<UploadMapControllerProvider>();
                final location = addNewStoryProvider.attachedLocation;

                if (location == null) return;

                await controllerProvider.animateCamera(
                  CameraPosition(target: location, zoom: 15),
                );
              },
              isLoading: uploadLocationLoadingProvider.isLoading,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildMapHeader(
    BuildContext context,
    AddNewStoryProvider addNewStoryProvider,
  ) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.location,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),

        Switch(
          value: addNewStoryProvider.isLocationAttached,
          onChanged: (value) {
            addNewStoryProvider.toggleLocationAttached(value);

            if (value &&
                addNewStoryProvider.attachedLocation == null &&
                !context.read<UploadLocationLoadingProvider>().isLoading) {
              _getCurrentPosition(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMapContainer(
    BuildContext context,
    AddNewStoryProvider addNewStoryProvider,
    UploadLocationLoadingProvider uploadLocationLoadingProvider,
  ) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: addNewStoryProvider.isLocationAttached ? 1.0 : 0.0,
      child: Container(
        height: 240.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (uploadLocationLoadingProvider.isLoading &&
                addNewStoryProvider.attachedLocation == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              BuildGoogleMapWidget(),

              Positioned(
                top: 12.0,
                left: 12.0,
                child: PointerInterceptor(
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      context.read<AppProvider>().openUploadFullScreenMap();
                    },
                    child: const Icon(Icons.fullscreen),
                  ),
                ),
              ),
            ],

            if (uploadLocationLoadingProvider.errorMessage != null &&
                addNewStoryProvider.attachedLocation == null)
              LocationErrorWidget(
                errorMsg: uploadLocationLoadingProvider.errorMessage!,
              ),

            if (addNewStoryProvider.attachedLocation == null &&
                !uploadLocationLoadingProvider.isLoading)
              LocationMapPlaceholderWidget(),

            if (uploadLocationLoadingProvider.isLoading &&
                addNewStoryProvider.attachedLocation != null)
              _buildLoadingIndicator(context),
          ],
        ),
      ),
    );
  }
}
