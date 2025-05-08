import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ApiResponse<T> {
  final T? data;
  final String? message;

  ApiResponse._({this.data, this.message});

  factory ApiResponse.success(T data) => ApiResponse._(data: data);
  factory ApiResponse.error(String message) => ApiResponse._(message: message);
}

Future<ApiResponse<T>> executeSafely<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return ApiResponse.success(result);
  } on ClientException {
    log("API Call Failed: ClientException");
    return ApiResponse.error(
      "Network request failed. Please check your connection.",
    );
  } on SocketException {
    log("API Call Failed: SocketException");
    return ApiResponse.error(
      "No internet connection. Please check your network.",
    );
  } on TimeoutException {
    log("API Call Failed: TimeoutException");
    return ApiResponse.error("The connection timed out. Please try again.");
  } on HttpException {
    log("API Call Failed: HttpException");
    return ApiResponse.error("An HTTP error occurred. Please try again.");
  } on FormatException {
    log("API Call Failed: FormatException");
    return ApiResponse.error("Invalid response format. Please contact support.");
  } on TypeError {
    log("API Call Failed: TypeError");
    return ApiResponse.error(
      "Unexpected data type encountered. Please try again.",
    );
  } on PlatformException catch (e) {
    log("API Call Failed: PlatformException - ${e.message}");
    return ApiResponse.error("A platform error occurred: ${e.message}");
  } on UnsupportedError {
    log("API Call Failed: UnsupportedError");
    return ApiResponse.error(
      "Unsupported operation encountered. Please try again.",
    );
  } on RangeError {
    log("API Call Failed: RangeError");
    return ApiResponse.error(
      "An out-of-bounds error occurred. Please try again.",
    );
  } on StateError {
    log("API Call Failed: StateError");
    return ApiResponse.error(
      "Invalid state encountered during operation. Please try again.",
    );
  } on JsonUnsupportedObjectError {
    log("API Call Failed: JsonUnsupportedObjectError");
    return ApiResponse.error("Failed to encode data to JSON. Please try again.");
  } catch (e, stackTrace) {
    log("API Call Failed: Unexpected error - $e", stackTrace: stackTrace);

    String errorMessage = e.toString();
    if (errorMessage.startsWith("Exception: ")) {
      errorMessage = errorMessage.replaceFirst("Exception: ", "");
    }

    return ApiResponse.error(errorMessage);
  }
}

