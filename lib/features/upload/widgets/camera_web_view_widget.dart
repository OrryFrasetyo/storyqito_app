import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/features/upload/services/camera_service.dart';

class CameraWebViewWidget extends StatelessWidget {
  final CameraService cameraService;

  const CameraWebViewWidget({super.key, required this.cameraService});

  @override
  Widget build(BuildContext context) {
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();

    if (addNewStoryProvider.isRequestPermission) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text(AppLocalizations.of(context)!.request_camera_permission),
          ],
        ),
      );
    }

    if (!addNewStoryProvider.isCameraInitialized ||
        cameraService.cameraController == null ||
        !cameraService.cameraController!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.initializing_camera),
          ],
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: CameraPreview(cameraService.cameraController!),
          ),
        ),
        const SizedBox(height: 18.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                cameraService.cleanUpCamera();
              },
            ),
            ElevatedButton(
              onPressed: () => cameraService.takePictureWeb(),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16.0),
              ),
              child: Icon(
                Icons.camera_alt,
                size: 28,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.flip_camera_android),
              onPressed: () => cameraService.switchCamera(),
            ),
          ],
        ),
      ],
    );
  }
}
