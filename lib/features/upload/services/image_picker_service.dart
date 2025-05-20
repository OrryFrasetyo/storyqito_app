import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/utils/constants.dart';

class ImagePickerService {
  final AppService appService = AppService();
  final ImagePicker _imagePicker = ImagePicker();
  BuildContext? _context;

  void initialize(BuildContext context) {
    _context = context;
  }

  Future<void> pickImage(ImageSource source) async {
    if (_context == null) return;
    final context = _context!;

    if (appService.getKIsWeb() && source == ImageSource.camera) {
      return;
    }

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        int fileSize = 0;

        if (appService.getKIsWeb()) {
          Uint8List bytes = await pickedFile.readAsBytes();
          fileSize = bytes.lengthInBytes;
        } else {
          final file = File(pickedFile.path);
          fileSize = await file.length();
        }

        if (fileSize > 1048576) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.image_too_large),
              ),
            );
          }
        } else {
          if (context.mounted) {
            Provider.of<AddNewStoryProvider>(
              context,
              listen: false,
            ).setImageFile(pickedFile);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${AppLocalizations.of(context)!.error_picking_image} $e",
            ),
          ),
        );
      }
    }
  }
}
