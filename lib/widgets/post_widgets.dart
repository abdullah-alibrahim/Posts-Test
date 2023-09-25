import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:posts_test/controllers/post.dart';
import 'package:posts_test/models/post.dart';
import 'package:video_player/video_player.dart';

Widget postWidget(PostModel postModel) {
  PageController controller = PageController();

  return Container(
    margin: EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                postModel.model.media.isNotEmpty
                    ? Container(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              LoadingAnimationWidget.threeArchedCircle(
                            size: 25,
                            color: Colors.blue,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl: postModel.model.media.first.srcUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white24,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2.0,
                                  offset: const Offset(0.0, 1.0),
                                ),
                              ],
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                      ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      postModel.model.name.toString(),
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    // Text(postModel.content, style: TextStyle(fontSize: 15, color: Colors.grey),),
                  ],
                )
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                size: 30,
                color: Colors.grey[600],
              ),
              onPressed: () {},
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          postModel.content,
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
              letterSpacing: .7),
        ),
        SizedBox(
          height: 20,
        ),
        postModel.media.isNotEmpty
            ? GetBuilder<PostController>(
                init: PostController(),
                builder: (postController) => Container(
                  height: 250,
                  child: PageView.builder(
                    itemCount: postModel.media.length,
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    onPageChanged: (value) {
                      postController.onPageChange(value);
                    },
                    itemBuilder: (context, index) => Column(
                      children: [
                        Container(
                          height: 170,
                          child: postModel.media[index].mediaType == 'Image'
                              ? CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: LoadingAnimationWidget
                                        .threeArchedCircle(
                                      size: 25,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  imageUrl: postModel.media[index].srcUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white24,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2.0,
                                          offset: const Offset(0.0, 1.0),
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : VideoPlayerView(
                                  url: postModel.media[index].srcUrl),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(postModel.media.length, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 8,
                                width: 8,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 30),
                                decoration: index == postController.currentPage
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.blue),
                                      )
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue),
                              );
                            })),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                makeLike(),
                Transform.translate(offset: Offset(-5, 0), child: makeLove()),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${postModel.interactionsCount}",
                  style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                )
              ],
            ),
            Text(
              "${postModel.commentsCount} Comments",
              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            makeLikeButton(isActive: false),
            makeCommentButton(),
            makeShareButton(),
          ],
        )
      ],
    ),
  );
}

class VideoPlayerView extends StatefulWidget {
  final String url;

  const VideoPlayerView({super.key, required this.url});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    videoPlayerController.initialize().then((_) => setState(() {
          chewieController = ChewieController(
              autoInitialize: true,
              videoPlayerController: videoPlayerController,
              aspectRatio: videoPlayerController.value.aspectRatio);
        }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio * 2,
            child: Chewie(controller: chewieController))
        : const SizedBox.shrink();
  }
}

Widget makeLike() {
  return Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white)),
    child: Center(
      child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
    ),
  );
}

Widget makeLove() {
  return Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white)),
    child: Center(
      child: Icon(Icons.favorite, size: 12, color: Colors.white),
    ),
  );
}

Widget makeLikeButton({isActive}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            color: isActive ? Colors.blue : Colors.grey,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Like",
            style: TextStyle(color: isActive ? Colors.blue : Colors.grey),
          )
        ],
      ),
    ),
  );
}

Widget makeCommentButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.chat, color: Colors.grey, size: 18),
          SizedBox(
            width: 5,
          ),
          Text(
            "Comment",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}

Widget makeShareButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.share, color: Colors.grey, size: 18),
          SizedBox(
            width: 5,
          ),
          Text(
            "Share",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
