import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyqito_app/core/data/repository/story_repository.dart';

class AddNewStoryProvider extends ChangeNotifier {
  final StoryRepository _storyRepository;

  AddNewStoryProvider(this._storyRepository);

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMsg;
  String _caption = "";
  XFile? _imageFile;

  bool _showCamera = false;
  bool _isCameraInitialized = false;
  bool _requestPermission = false;
  List<CameraDescription>? _cameras;

  bool get isLoading => _isLoading;
  String? get errorMsg => _errorMsg;
  bool get isSuccess => _isSuccess;
  String get caption => _caption;
  XFile? get imageFile => _imageFile;

  bool get showCamera => _showCamera;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isRequestPermission => _requestPermission;
  List<CameraDescription>? get cameras => _cameras;

  void setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }

  void setCaption(String caption) {
    _caption = caption;
    notifyListeners();
  }

  void setShowCamera(bool show) {
    _showCamera = show;
    notifyListeners();
  }

  void setIsCameraInitialized(bool initialized) {
    _isCameraInitialized = initialized;
    notifyListeners();
  }

  void setRequestPermission(bool request) {
    _requestPermission = request;
    notifyListeners();
  }

  void setCameras(List<CameraDescription> cameras) {
    _cameras = cameras;
    notifyListeners();
  }

  void resetCamera() {
    _showCamera = false;
    _isCameraInitialized = false;
    _requestPermission = false;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMsg = null;
    _caption = "";
    _imageFile = null;
    notifyListeners();
  }

  void resetAll() {
    reset();
    resetCamera();
  }

  Future<void> addNewStory({
    required String token,
    required String description,
    File? photoFile,
    Uint8List? photoBytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    _isLoading = true;
    _errorMsg = null;
    _isSuccess = false;
    notifyListeners();

    final result = await _storyRepository.addNewStory(
      token: token,
      description: description,
      photoFile: photoFile,
      photoBytes: photoBytes,
      fileName: fileName,
      lat: lat,
      lon: lon,
    );

    if (result.data != null) {
      _isSuccess = true;
    } else {
      _errorMsg = result.message ?? "Unknown error occurred";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> uploadStoryWithFile({
    required String token,
    required String description,
    required XFile imageFile,
  }) async {
    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      return addNewStory(
        token: token,
        description: description,
        fileName: imageFile.name,
        photoBytes: bytes,
      );
    } else {
      final file = File(imageFile.path);
      return addNewStory(
        token: token,
        description: description,
        fileName: imageFile.name,
        photoFile: file,
      );
    }
  }
}
