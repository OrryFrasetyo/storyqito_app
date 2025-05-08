import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/add_new_story_provider.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/story_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  CameraController? _cameraController;
  AddNewStoryProvider? _addNewStoryProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addNewStoryProvider = context.read<AddNewStoryProvider>();
  }

  @override
  void dispose() {
    _cleanUpCamera();
    _addNewStoryProvider = null;
    super.dispose();
  }

  void _cleanUpCamera() {
    _cameraController?.dispose();
    _cameraController = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addNewStoryProvider?.setIsCameraInitialized(false);
      _addNewStoryProvider?.setShowCamera(false);
    });
  }

  bool _isChromeMobile() {
    if (!kIsWeb) return false;

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains("chrome") &&
          (userAgent.contains("android") || userAgent.contains("mobile"));
    } catch (e) {
      log('Error detecting browser: $e');
      return false;
    }
  }

  Future<bool> _requestWebCameraPermission() async {
    final localization = AppLocalizations.of(context)!;
    final provider = context.read<AddNewStoryProvider>();
    if (provider.isrequestPermission) return false;

    provider.setRequestPermission(true);

    try {
      final isChromeMobile = _isChromeMobile();

      final videoConstraints =
          isChromeMobile
              ? {
                "facingMode": {"exact": "environment"},
                "width": {"ideal": 720, "max": 1280},
                "height": {"ideal": 480, "max": 720},
              }
              : true;

      await html.window.navigator.mediaDevices!.getUserMedia({
        'video': videoConstraints,
        'audio': false,
      });

      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        provider.setCameras(cameras);
        provider.setRequestPermission(false);
        return true;
      }
      return false;
    } catch (e) {
      log('Camera access error details: $e');

      if (mounted) {
        String errorMessage = '${localization.camera_access_denied} $e';
        if (e.toString().contains("notReadable")) {
          errorMessage = localization.camera_used_by_other;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      provider.setRequestPermission(false);
      return false;
    }
  }

  Future<void> _useFallbackCameraInput() async {
    final localization = AppLocalizations.of(context)!;
    try {
      final inputElement =
          html.FileUploadInputElement()
            ..accept = "image/*"
            ..setAttribute("capture", "environment");

      // add to DOM temporarily
      html.document.body!.append(inputElement);

      // trigger click
      inputElement.click();

      // create a completer to handle async file selection
      final completer = Completer<void>();

      inputElement.onChange.listen((event) async {
        if (inputElement.files!.isNotEmpty) {
          final file = inputElement.files![0];
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoad.listen((event) async {
            final bytes = reader.result as Uint8List;
            if (bytes.lengthInBytes > 1048576) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.image_too_large)),
                );
              }
            } else {
              if (mounted) {
                final path = "data:image/jpeg;base64,${base64Encode(bytes)}";
                final xFile = XFile.fromData(
                  bytes,
                  name: file.name,
                  path: path,
                  mimeType: file.type,
                );
                context.read<AddNewStoryProvider>().setImageFile(xFile);
              }
            }
            completer.complete();
          });
        } else {
          completer.complete(); // complete even if no file was selected
        }
        // remove from DOM
        inputElement.remove();
      });

      return completer.future;
    } catch (e) {
      log("Fallback camera error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${localization.error_accessing_camera} $e")),
        );
      }
    }
  }

  Future<void> _initializeWebCamera() async {
    final provider = context.read<AddNewStoryProvider>();
    final cameras = provider.cameras;

    if (cameras != null && cameras.isNotEmpty) {
      final isChromeMobile = _isChromeMobile();

      final preset = ResolutionPreset.medium;

      try {
        CameraDescription cameraToUse = cameras[0];
        if (isChromeMobile && cameras.length > 1) {
          for (var camera in cameras) {
            if (camera.lensDirection == CameraLensDirection.back) {
              cameraToUse = camera;
              break;
            }
          }
        }

        _cameraController = CameraController(
          cameraToUse,
          preset,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        await _cameraController!.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException("Camera initialization timed out");
          },
        );

        if (mounted) {
          provider.setIsCameraInitialized(true);
          provider.setShowCamera(true);
        }
      } catch (e) {
        log("Initialization camera error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${AppLocalizations.of(context)!.error_initializing_camera} $e",
              ),
            ),
          );
        }
        _cleanUpCamera();

        if (isChromeMobile) {
          await _useFallbackCameraInput();
        }
      }
    }
  }

  Future<void> _takePictureWeb() async {
    final localizations = AppLocalizations.of(context)!;
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await _cameraController!.takePicture();

      int fileSize = 0;
      Uint8List? bytes = await picture.readAsBytes();
      fileSize = bytes.lengthInBytes;

      if (fileSize > 1048576) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.image_too_large)),
          );
        }
      } else {
        if (mounted) {
          final provider = context.read<AddNewStoryProvider>();
          provider.setImageFile(picture);
          provider.setShowCamera(false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${localizations.error_taking_picture} $e")),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final localizations = AppLocalizations.of(context)!;
    if (kIsWeb && source == ImageSource.camera) {
      await _handleCameraButton();
      return;
    }

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        int fileSize = 0;

        if (kIsWeb) {
          Uint8List bytes = await pickedFile.readAsBytes();
          fileSize = bytes.lengthInBytes;
        } else {
          final file = File(pickedFile.path);
          fileSize = await file.length();
        }

        if (fileSize > 1048576) {
          // File too big
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.image_too_large)),
            );
          }
        } else {
          if (mounted) {
            context.read<AddNewStoryProvider>().setImageFile(pickedFile);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${localizations.error_picking_image} $e")),
        );
      }
    }
  }

  Future<void> _handleCameraButton() async {
    if (kIsWeb) {
      final isChromeMobile = _isChromeMobile();

      if (isChromeMobile) {
        try {
          final bool hasPermission = await _requestWebCameraPermission();
          if (hasPermission) {
            await _initializeWebCamera();
          } else {
            await _useFallbackCameraInput();
          }
        } catch (e) {
          log("Standard camera access failed, trying fallback: $e");
          await _useFallbackCameraInput();
        }
      } else {
        final bool hasPermission = await _requestWebCameraPermission();
        if (hasPermission) {
          await _initializeWebCamera();
        }
      }
    } else {
      _pickImage(ImageSource.camera);
    }
  }

  Future<void> _uploadStory() async {
    final localizations = AppLocalizations.of(context)!;
    final addNewStoryProvider = context.read<AddNewStoryProvider>();
    final authProvider = context.read<AuthProvider>();

    final imageFile = addNewStoryProvider.imageFile;
    final caption = addNewStoryProvider.caption;

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
    addNewStoryProvider.reset();

    final token = authProvider.user?.token ?? "";

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      await addNewStoryProvider.addNewStory(
        token: token,
        description: caption,
        photoBytes: bytes,
        fileName: imageFile.name,
      );
    } else {
      final file = File(imageFile.path);
      await addNewStoryProvider.addNewStory(
        token: token,
        description: caption,
        photoFile: file,
        fileName: imageFile.name,
      );
    }

    if (!mounted) return;

    if (addNewStoryProvider.isSuccess) {
      _cleanUpCamera();

      context.read<StoryProvider>().refreshStories(user: authProvider.user!);
      context.read<MyRouteDelegate>().navigateToHome();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.story_upload_success)),
      );
      addNewStoryProvider.reset();
    } else if (addNewStoryProvider.errorMsg != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(addNewStoryProvider.errorMsg!)));
    }
  }

  Widget _buildImagePlaceholder() {
    final localizations = AppLocalizations.of(context)!;
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();

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
                    addNewStoryProvider.isrequestPermission
                        ? null
                        : () => _handleCameraButton(),
                icon: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                label: Text(
                  localizations.camera,
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
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  localizations.gallery,
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

  Widget _buildImagePreview(XFile? imageFile) {
    if (imageFile == null) {
      return _buildImagePlaceholder();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child:
          kIsWeb
              ? Image.network(imageFile.path)
              : Image.file(File(imageFile.path)),
    );
  }

  Widget _buildCameraViewWeb() {
    final localizations = AppLocalizations.of(context)!;
    final addNewStoryProvider = context.watch<AddNewStoryProvider>();

    if (addNewStoryProvider.isrequestPermission) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            Text(localizations.request_camera_permission),
          ],
        ),
      );
    }

    if (!addNewStoryProvider.isCameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(localizations.initializing_camera),
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
            child: CameraPreview(_cameraController!),
          ),
        ),
        const SizedBox(height: 18.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _cleanUpCamera();
              },
            ),
            ElevatedButton(
              onPressed: _takePictureWeb,
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
              onPressed: () async {
                final cameras = addNewStoryProvider.cameras;
                if (cameras != null && cameras.length > 1) {
                  final currentLensDirection =
                      _cameraController!.description.lensDirection;
                  CameraDescription newCamera;

                  if (currentLensDirection == CameraLensDirection.back) {
                    newCamera = cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.front,
                      orElse: () => cameras[0],
                    );
                  } else {
                    newCamera = cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.back,
                      orElse: () => cameras[0],
                    );
                  }

                  context.read<AddNewStoryProvider>().setIsCameraInitialized(
                    false,
                  );

                  await _cameraController!.dispose();
                  _cameraController = CameraController(
                    newCamera,
                    ResolutionPreset.medium,
                  );

                  try {
                    await _cameraController!.initialize();
                    if (mounted) {
                      context
                          .read<AddNewStoryProvider>()
                          .setIsCameraInitialized(true);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${localizations.error_switching_camera} $e",
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                      _buildCameraViewWeb()
                    else
                      _buildImagePreview(imageFile),
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
