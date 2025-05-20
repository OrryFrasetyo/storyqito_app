import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/utils/constants.dart';

class ImagePreviewWidget extends StatelessWidget {
  final XFile? imageFile;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImagePreviewWidget({
    super.key,
    required this.imageFile,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AppService appService = AppService();

    if (imageFile == null) {
      return _buildImagePlaceholder(context);
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child:
          appService.getKIsWeb()
              ? Image.network(imageFile!.path)
              : Image.file(File(imageFile!.path)),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final addNewStoryProvider = Provider.of<AddNewStoryProvider>(context);

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed:
                    addNewStoryProvider.isRequestPermission
                        ? null
                        : onCameraPressed,
                icon: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                label: Text(
                  AppLocalizations.of(context)!.camera,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: onGalleryPressed,
                icon: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  AppLocalizations.of(context)!.gallery,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
