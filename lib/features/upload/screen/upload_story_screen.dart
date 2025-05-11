import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/features/upload/services/camera_service.dart';
import 'package:storyqito_app/features/upload/services/image_picker_service.dart';
import 'package:storyqito_app/features/upload/widgets/camera_web_view_widget.dart';
import 'package:storyqito_app/features/upload/widgets/image_preview_widget.dart';

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  late final CameraService _cameraService;
  late final ImagePickerService _imagePickerService;
  AddNewStoryProvider? _addNewStoryProvider;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _imagePickerService = ImagePickerService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addNewStoryProvider = context.read<AddNewStoryProvider>();

    _cameraService.initialize(context);
    _imagePickerService.initialize(context);
  }

  @override
  void dispose() {
    _cameraService.cleanUpCamera();
    _addNewStoryProvider = null;
    super.dispose();
  }

  Future<void> _handleCameraButton() async {
    if (kIsWeb) {
      await _cameraService.handleCameraButton();
    } else {
      await _imagePickerService.pickImage(ImageSource.camera);
    }
  }

  Future<void> _uploadStory() async {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();

    final imageFile = _addNewStoryProvider!.imageFile;
    final caption = _addNewStoryProvider!.caption;

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.please_select_image)),
      );
      return;
    }

    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.please_write_description)),
      );
      return;
    }

    authProvider.getUser();
    _addNewStoryProvider!.reset();

    final token = authProvider.user?.token ?? "";

    await _addNewStoryProvider!.uploadStoryWithFile(
      token: token,
      description: caption,
      imageFile: imageFile,
    );

    if (!mounted) return;

    if (_addNewStoryProvider!.isSuccess) {
      _cameraService.cleanUpCamera();

      context.read<MyRouteDelegate>().navigateToHome();
      // TODO : yang await ini waspada
      context.read<StoryProvider>().refreshStories(
        user: authProvider.user!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.story_upload_success)),
      );
      _addNewStoryProvider!.reset();
    } else if (_addNewStoryProvider!.errorMsg != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_addNewStoryProvider!.errorMsg!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();
    final imageFile = addNewStoryProvider.imageFile;
    final isUploading = addNewStoryProvider.isLoading;
    final showCamera = addNewStoryProvider.showCamera;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localization.upload_story,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        actions: [
          if (imageFile != null && !showCamera)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.check),
                onPressed: isUploading ? null : _uploadStory,
              ),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 475),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showCamera)
                      CameraWebViewWidget(cameraService: _cameraService)
                    else
                      ImagePreviewWidget(
                        imageFile: imageFile,
                        onCameraPressed: _handleCameraButton,
                        onGalleryPressed:
                            () => _imagePickerService.pickImage(
                              ImageSource.gallery,
                            ),
                      ),
                    const SizedBox(height: 16),
                    if (imageFile != null && !showCamera) ...[
                      TextField(
                        decoration: InputDecoration(
                          hintText: localization.write_a_description,
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          addNewStoryProvider.setCaption(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed:
                            isUploading
                                ? null
                                : () => addNewStoryProvider.reset(),
                        icon: Icon(
                          Icons.refresh,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerLowest,
                        ),
                        label: Text(localization.change_image),
                      ),
                    ],
                    if (isUploading) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                      const SizedBox(height: 8),
                      Center(child: Text(localization.uploading_story)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
