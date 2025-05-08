import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/response/login_response.dart';
import 'package:storyqito_app/core/data/network/response/simple_response.dart';
import 'package:storyqito_app/core/data/network/response/stories_response.dart';
import 'package:storyqito_app/core/data/network/util/api_response.dart';

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<ApiResponse<SimpleResponse>> register(User user) async {
    return await executeSafely(() async {
      final response = await httpClient.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": user.name,
          "email": user.email,
          "password": user.password,
        }),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SimpleResponse.fromJson(json);
      } else {
        final errorMsg = json["message"] ?? "Unknown error occurred";
        throw Exception(errorMsg);
      }
    });
  }

  Future<ApiResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    return await executeSafely(() async {
      final response = await httpClient.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(json);
      } else {
        final errorMsg = json["message"] ?? "Login failed";
        throw Exception(errorMsg);
      }
    });
  }

  Future<ApiResponse<StoriesResponse>> getStories({
    int? page,
    int? size,
    int location = 0,
    required User user,
  }) async {
    return await executeSafely(() async {
      final queryParams = <String, String>{};
      if (page != null) {
        queryParams["page"] = page.toString();
      }
      if (size != null) {
        queryParams["size"] = size.toString();
      }
      queryParams["location"] = location.toString();

      final uri = Uri.parse(
        "$_baseUrl/stories",
      ).replace(queryParameters: queryParams);
      final response = await httpClient.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );
      if (response.statusCode == 200) {
        return StoriesResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "Failed to fetch stories. Status code: ${response.statusCode}",
        );
      }
    });
  }

  Future<ApiResponse<SimpleResponse>> addNewStory({
    required String token,
    required String description,
    File? photoFile,
    Uint8List? photoBytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    return await executeSafely(() async {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$_baseUrl/stories"),
      );

      request.headers.addAll({"Authorization": "Bearer $token"});
      request.fields["description"] = description;

      if (lat != null) request.fields["lat"] = lat.toString();
      if (lon != null) request.fields["lon"] = lon.toString();

      final extension = path.extension(fileName).toLowerCase();
      final mimeType = MediaType("image", _getImageMimeType(extension));

      if (kIsWeb && photoBytes != null) {
        final multipart = http.MultipartFile.fromBytes(
          "photo",
          photoBytes,
          filename: fileName,
          contentType: mimeType,
        );
        request.files.add(multipart);
      } else if (photoFile != null) {
        final photoStream = http.ByteStream(photoFile.openRead());
        final photoLength = await photoFile.length();
        final multipart = http.MultipartFile(
          "photo",
          photoStream,
          photoLength,
          filename: path.basename(photoFile.path),
          contentType: mimeType,
        );
        request.files.add(multipart);
      } else {
        throw Exception("Tidak ada file gambar yang disediakan");
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SimpleResponse.fromJson(json);
      } else {
        final errorMsg = json["message"] ?? "Unknown error occurred";
        throw Exception(errorMsg);
      }
    });
  }

  String _getImageMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'jpeg';
      case '.png':
        return 'png';
      case '.gif':
        return 'gif';
      default:
        return 'jpeg';
    }
  }
}
