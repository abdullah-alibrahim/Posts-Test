import 'dart:convert';
import 'dart:io';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:posts_test/constants/constants.dart';
import 'package:posts_test/models/post.dart';
import 'package:posts_test/utils/post_util.dart';

class PostController extends GetxController {
  List<PostModel> _posts = [];
  List<PostModel> get getPosts {
    return [..._posts];
  }

  Future<List<PostModel>> fetchPosts(String? page, String? limit) async {
    _posts = _posts + await GetPosts(page!, limit!);
    // print('customer list is ${_customer[0].DEFINITION_}');
    return _posts;
  }

  Future<List<PostModel>> GetPosts(
    String page,
    String limit,
  ) async {
    try {
      String responseBody = await PostUtil.doGet(
          url: Constants.baseUrl + Constants.posts, page: page, limit: limit);
      print('parsed is');

      final parsed = jsonDecode(responseBody);
      print(parsed.toString());
      print('status is');
      print(parsed['status']);
      List TempList = [];
      print('start add to list');
      for (var v in parsed['data']['items']) {
        TempList.add(v);
        print('list is $TempList');
      }
      print('end add to list');

      return PostModel.postFromSnapshot(TempList);
    } catch (error) {
      throw error.toString();
    }
  }

  int currentPage = 0;

  onPageChange(int initialPage) {
    currentPage = initialPage;
    update();
  }
}
