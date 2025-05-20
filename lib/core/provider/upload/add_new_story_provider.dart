import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyqito_app/core/data/repository/story_repository.dart';
import 'package:storyqito_app/core/utils/constants.dart';

class AddNewStoryProvider extends ChangeNotifier {
  final AppService appService;
  final StoryRepository storyRepository;

  AddNewStoryProvider({
    required this.storyRepository,
    required this.appService,
  });

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMsg;
  String _description = "";
  XFile? _imageFile;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMsg => _errorMsg;
  String get description => _description;
  XFile? get imageFile => _imageFile;

  bool _showCamera = false;
  bool _isCameraInitialized = false;
  bool _requestPermission = false;
  List<CameraDescription>? _cameras;

  bool get showCamera => _showCamera;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isRequestPermission => _requestPermission;
  List<CameraDescription>? get cameras => _cameras;

  bool _isLocationAttached = false;
  LatLng? _attachedLocation;

  bool get isLocationAttached => _isLocationAttached;
  LatLng? get attachedLocation => _attachedLocation;

  void setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
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

  void toggleLocationAttached(bool value) {
    _isLocationAttached = value;
    notifyListeners();
  }

  void setAttachedLocation(LatLng? location) {
    _attachedLocation = location;
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
    _description = "";
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

    final result = await storyRepository.addNewStory(
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
    double? lat,
    double? lon,
  }) async {
    if (appService.getKIsWeb()) {
      final bytes = await imageFile.readAsBytes();
      return addNewStory(
        token: token,
        description: description,
        fileName: imageFile.name,
        photoBytes: bytes,
        lat: lat,
        lon: lon,
      );
    } else {
      final file = File(imageFile.path);
      return addNewStory(
        token: token,
        description: description,
        fileName: imageFile.name,
        photoFile: file,
        lat: lat,
        lon: lon,
      );
    }
  }
}
