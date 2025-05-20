import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/provider/story/story_provider.dart';
import 'package:storyqito_app/core/routes/app_router.dart';
import 'package:storyqito_app/core/utils/constants.dart';
import 'package:storyqito_app/core/variant/build_config.dart';
import 'package:storyqito_app/features/upload/services/camera_service.dart';
import 'package:storyqito_app/features/upload/services/image_picker_service.dart';
import 'package:storyqito_app/features/upload/widgets/build_premium_feature.dart';
import 'package:storyqito_app/features/upload/widgets/camera_web_view_widget.dart';
import 'package:storyqito_app/features/upload/widgets/image_preview_widget.dart';
import 'package:storyqito_app/features/upload/widgets/location_map_selector_widget.dart';

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  late final CameraService _cameraService;
  late final ImagePickerService _imagePickerService;
  late AddNewStoryProvider _addNewStoryProvider;
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AppService _appService = AppService();

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _imagePickerService = ImagePickerService();
    _descriptionController.text =
        context.read<AddNewStoryProvider>().description;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addNewStoryProvider = context.read<AddNewStoryProvider>();

    _cameraService.initialize(context);
    _imagePickerService.initialize(context);
    if (_addNewStoryProvider.isLocationAttached) {
      _scrollToLocationSelector();
    }
  }

  @override
  void dispose() {
    _cameraService.cleanUpCamera();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLocationSelector() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _handleCameraButton() async {
    if (_appService.getKIsWeb()) {
      await _cameraService.handleWebCamera();
    } else {
      await _imagePickerService.pickImage(ImageSource.camera);
    }
  }

  Future<void> _uploadStory() async {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final imageFile = _addNewStoryProvider.imageFile;
    final description = _addNewStoryProvider.description;

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.please_select_image)),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.please_write_description)),
      );
      return;
    }

    authProvider.getUser();

    final token = authProvider.user?.token ?? "";
    double? lat;
    double? lon;

    if (_addNewStoryProvider.isLocationAttached &&
        _addNewStoryProvider.attachedLocation != null) {
      lat = _addNewStoryProvider.attachedLocation!.latitude;
      lon = _addNewStoryProvider.attachedLocation!.longitude;
    }

    await _addNewStoryProvider.uploadStoryWithFile(
      token: token,
      description: description,
      imageFile: imageFile,
      lat: lat,
      lon: lon,
    );

    if (!mounted) return;

    if (_addNewStoryProvider.isSuccess) {
      _cameraService.cleanUpCamera();

      _addNewStoryProvider.reset();

      _descriptionController.clear();

      context.navigateToHome();

      await context.read<StoryProvider>().refreshStories(
        user: authProvider.user!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.story_upload_success)),
        );
      }
      _addNewStoryProvider.reset();
    } else if (_addNewStoryProvider.errorMsg != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_addNewStoryProvider.errorMsg!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();
    final AppService appService = AppService();
    final imageFile = addNewStoryProvider.imageFile;
    final showCamera = addNewStoryProvider.showCamera;
    final isUploading = addNewStoryProvider.isLoading;
    final appFlavor = const String.fromEnvironment(
      "APP_FLAVOR",
      defaultValue: "free",
    );
    final isPaidVersion = appFlavor == "paid";

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
          controller: _scrollController,
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
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: localization.write_a_description,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          addNewStoryProvider.setDescription(value);
                        },
                      ),
                      const SizedBox(height: 16),

                      if (appService.getKIsWeb()) ...[
                        if (isPaidVersion)
                          StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return LocationMapSelectorWidget();
                            },
                          )
                        else
                          BuildPremiumFeature(),
                      ] else if (Theme.of(context).platform ==
                          TargetPlatform.android) ...[
                        if (BuildConfig.canAddLocation) ...[
                          StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return LocationMapSelectorWidget();
                            },
                          ),
                        ] else ...[
                          BuildPremiumFeature(),
                        ],
                      ],

                      const SizedBox(height: 16.0),

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
