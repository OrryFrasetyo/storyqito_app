import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/core/utils/constants.dart';
import 'package:storyqito_app/features/upload/util/web_camera_util.dart';

class CameraService {
  final AppService appService = AppService();
  CameraController? _cameraController;
  BuildContext? _context;
  late final WebCameraUtil _webCameraUtil = WebCameraUtil();
  late AppLocalizations _localizations;
  late AddNewStoryProvider _addNewStoryProvider;

  CameraController? get cameraController => _cameraController;

  void initialize(BuildContext context) {
    _context = context;
    _localizations = AppLocalizations.of(_context!)!;
    _addNewStoryProvider = Provider.of<AddNewStoryProvider>(
      context,
      listen: false,
    );
  }

  void cleanUpCamera() {
    _cameraController?.dispose();
    _cameraController = null;

    if (_context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addNewStoryProvider.setIsCameraInitialized(false);
        _addNewStoryProvider.setShowCamera(false);
      });
    }
  }

  Future<void> handleWebCamera() async {
    if (!appService.getKIsWeb() || _context == null) return;

    final context = _context!;

    if (_webCameraUtil.isChromeMobile()) {
      try {
        final bool hasPermission = await _requestWebCameraPermission();
        if (hasPermission) {
          await _initializeWebCamera();
        } else {
          if (context.mounted) {
            await _webCameraUtil.useFallbackCameraInput(context);
          }
        }
      } catch (e) {
        log("Standard camera access failed, trying fallback: $e");
        if (context.mounted) {
          await _webCameraUtil.useFallbackCameraInput(context);
        }
      }
    } else {
      final bool hasPermission = await _requestWebCameraPermission();
      if (hasPermission) {
        await _initializeWebCamera();
      }
    }
  }

  Future<bool> _requestWebCameraPermission() async {
    if (_context == null) return false;
    final context = _context!;
    final provider = Provider.of<AddNewStoryProvider>(context, listen: false);

    if (provider.isRequestPermission) return false;

    provider.setRequestPermission(true);

    try {
      final hasPermission = await _webCameraUtil.requestWebCameraPermission();

      if (hasPermission) {
        final cameras = await availableCameras();

        if (cameras.isNotEmpty) {
          provider.setCameras(cameras);
          provider.setRequestPermission(false);
          return true;
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_localizations.camera_access_denied)),
          );
        }
      }

      provider.setRequestPermission(false);
      return false;
    } catch (e) {
      log("Camera access error details: $e");

      if (_context != null && _context!.mounted) {
        String errorMessage = "${_localizations.camera_access_denied} $e";
        if (e.toString().contains("notReadable")) {
          errorMessage = _localizations.camera_used_by_other;
        }

        ScaffoldMessenger.of(
          _context!,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      provider.setRequestPermission(false);
      return false;
    }
  }

  Future<void> _initializeWebCamera() async {
    if (_context == null) return;
    final context = _context!;
    final provider = Provider.of<AddNewStoryProvider>(context, listen: false);
    final cameras = provider.cameras;

    if (cameras != null && cameras.isNotEmpty) {
      final isChromeMobile = _webCameraUtil.isChromeMobile();

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

        if (context.mounted) {
          provider.setIsCameraInitialized(true);
          provider.setShowCamera(true);
        }
      } catch (e) {
        log("Initialization camera error: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${AppLocalizations.of(context)!.error_initializing_camera} $e",
              ),
            ),
          );
        }
        cleanUpCamera();

        if (isChromeMobile && context.mounted) {
          await _webCameraUtil.useFallbackCameraInput(context);
        }
      }
    }
  }

  Future<void> takePictureWeb() async {
    if (_context == null) return;

    final context = _context!;

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile picture = await _cameraController!.takePicture();
      final bytes = await picture.readAsBytes();
      final fileSize = bytes.lengthInBytes;

      if (fileSize > 1048576) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_localizations.image_too_large)),
          );
        }
      } else {
        if (context.mounted) {
          final provider = Provider.of<AddNewStoryProvider>(
            context,
            listen: false,
          );
          provider.setImageFile(picture);
          provider.setShowCamera(false);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${_localizations.error_taking_picture} $e")),
        );
      }
    }
  }

  Future<void> switchCamera() async {
    if (_context == null) return;
    final context = _context!;
    final provider = Provider.of<AddNewStoryProvider>(context, listen: false);
    final cameras = provider.cameras;

    if (cameras == null || cameras.length <= 1 || _cameraController == null) {
      return;
    }

    final currentLensDirection = _cameraController!.description.lensDirection;
    CameraDescription newCamera;

    if (currentLensDirection == CameraLensDirection.back) {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras[0],
      );
    } else {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras[0],
      );
    }

    provider.setIsCameraInitialized(false);

    await _cameraController!.dispose();
    _cameraController = CameraController(newCamera, ResolutionPreset.medium);

    try {
      await _cameraController!.initialize();
      if (context.mounted) {
        provider.setIsCameraInitialized(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_localizations.error_switching_camera} $e'),
          ),
        );
      }
    }
  }
}
