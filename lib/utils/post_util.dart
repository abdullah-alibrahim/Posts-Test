// Packages

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PostUtil {
  static Future<String> doGet(
      {required String url, String? page, String? limit}) async {
    Map<String, String> headers = {
      "Accept": 'application/json',
    };

    debugPrint("---------------------");
    debugPrint("The Header of PostUtil is: $headers");
    debugPrint("---------------------");

    debugPrint("---------------------");
    debugPrint("The URL for PostUtil is: $url");
    debugPrint("---------------------");

    var parsedUrl = Uri.parse(url);

    var params = {
      'page': page,
      'limit': limit,
    };

    parsedUrl = Uri.https(parsedUrl.authority, parsedUrl.path, params);

    final response = await http.get(parsedUrl);

    debugPrint("---------------------");
    debugPrint(
        "The status code of response of PostUtil is: ${response.statusCode}");
    debugPrint("---------------------");

    debugPrint("---------------------");
    debugPrint("The Response Body of PostUtil is: ${response.body}");
    debugPrint("---------------------");

    return response.body;
  }
}

class AddPostUtil {
  static Future<String> addPost({
    required String url,
    required String token,
    required String content,
  }) async {
    Map<String, String> body = {
      'content': content,
    };

    Map<String, String> headers = {
      "Accept": 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint("--------------------");
    debugPrint("The URL of addPost is: $url");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("The Body of addPost Request is: $body");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("The headers of addPost Request is: $headers");
    debugPrint("--------------------");
    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    debugPrint("--------------------");
    debugPrint(
        "The status code of response of addPost: ${response.statusCode}");
    debugPrint("--------------------");

    debugPrint("--------------------");
    debugPrint("The Body of response of addPost : ${response.body}");
    debugPrint("--------------------");

    return response.body;
  }
}

class AddPostWithImageUtil {
  static Future<String> addImagePost({
    required String url,
    required String token,
    required String content,
    required List<String> imageUrls,
    required List<String> idImages,
    required List<int> sizeImages,
  }) async {
    Map<String, String> body = {
      'content': content,
      for (int i = 0; i < imageUrls.length; i++)
        "media[$i][src_url]": imageUrls[i],
      for (int i = 0; i < imageUrls.length; i++)
        "media[$i][media_type]": "Image",
      for (int i = 0; i < imageUrls.length; i++) "media[$i][mime_type]": "jpg",
      for (int i = 0; i < imageUrls.length; i++)
        "media[$i][fullPath]": "media/$idImages.jpg",
      for (int i = 0; i < imageUrls.length; i++)
        "media[$i][size]": '${sizeImages[i]}',
    };

    Map<String, String> headers = {
      "Accept": 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint("--------------------");
    debugPrint("The URL of addPostWithImage is: $url");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("The Body of addPostWithImage Request is: $body");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("The headers of addPostWithImage Request is: $headers");
    debugPrint("--------------------");
    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    debugPrint("--------------------");
    debugPrint(
        "The status code of response of addPostWithImage: ${response.statusCode}");
    debugPrint("--------------------");

    debugPrint("--------------------");
    debugPrint("The Body of response of addPostWithImage : ${response.body}");
    debugPrint("--------------------");

    return response.body;
  }
}

class AddPostWithVideoUtil {
  static Future<String> addVideoPost({
    required String url,
    required String token,
    required String content,
    required String videoUrl,
    required String videoSize,
    required String videoWidth,
    required String videoHeight,
  }) async {
    Map<String, String> body = {
      'content': content,
      "media[0][src_url]": videoUrl,
      "media[0][media_type]": "Video",
      "media[0][width]": videoWidth,
      "media[0][height]": videoHeight,
      "media[0][mime_type]": "mp4",
      "media[0][fullPath]": "file/video.mp4",
      "media[0][size]": videoSize,
    };

    Map<String, String> headers = {
      "Accept": 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint("--------------------");
    debugPrint("The URL of addPostWithVideo is: $url");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("The Body of addPostWithVideo Request is: $body");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("--------------------");
    debugPrint("The headers of addPostWithVideo Request is: $headers");
    debugPrint("--------------------");
    final response =
        await http.post(Uri.parse(url), body: body, headers: headers);
    debugPrint("--------------------");
    debugPrint(
        "The status code of response of addPostWithVideo: ${response.statusCode}");
    debugPrint("--------------------");

    debugPrint("--------------------");
    debugPrint("The Body of response of addPostWithVideo : ${response.body}");
    debugPrint("--------------------");

    return response.body;
  }
}
