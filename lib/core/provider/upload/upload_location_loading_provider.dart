import 'package:flutter/material.dart';

class UploadLocationLoadingProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMsg;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMsg;

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMsg = message;
    notifyListeners();
  }
}
