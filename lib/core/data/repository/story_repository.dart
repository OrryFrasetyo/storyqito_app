import 'dart:io';
import 'dart:typed_data';

import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/response/simple_response.dart';
import 'package:storyqito_app/core/data/network/response/stories_response.dart';
import 'package:storyqito_app/core/data/network/service/api_services.dart';
import 'package:storyqito_app/core/data/network/util/api_response.dart';

class StoryRepository {
  final ApiServices _apiServices;

  StoryRepository(this._apiServices);

  Future<ApiResponse<StoriesResponse>> getStories({
    int? page,
    int? size,
    int location = 0,
    required User user,
  }) async {
    return await _apiServices.getStories(
      page: page,
      size: size,
      location: location,
      user: user,
    );
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
    return await _apiServices.addNewStory(
      token: token,
      description: description,
      photoFile: photoFile,
      photoBytes: photoBytes,
      fileName: fileName,
      lat: lat,
      lon: lon,
    );
  }
}
