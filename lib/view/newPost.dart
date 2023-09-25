import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:posts_test/constants/constants.dart';
import 'package:posts_test/utils/post_util.dart';
import 'package:video_player/video_player.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController _contentController = new TextEditingController();

  String _value = "0";

  final controller = MultiImagePickerController(
      maxImages: 15,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: true,
      withReadStream: true,
      images: <ImageFile>[] // array of pre/default selected images
      );
  File? _videoFile;
  String _uploadMessage = '';
  String _videoUrl = '';
  String _videoSize = '';
  String _videoWidth = '';
  String _videoHeight = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15, top: 15),
              child: Row(
                children: [
                  Text(
                    'Post Content',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                maxLines: 5,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Write What You Want...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.1,
                          style: BorderStyle.solid)),
                ),
                controller: _contentController,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    'Upload Media:  ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'No Media',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Radio(
                      value: "0",
                      groupValue: _value,
                      activeColor: Colors.blue,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return (_value == '0') ? Colors.blue : Colors.grey;
                      }),
                      onChanged: (value) {
                        setState(() {
                          _value = value.toString();
                        });
                      }),
                  Text(
                    'Images',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Radio(
                      value: "1",
                      groupValue: _value,
                      activeColor: Colors.blue,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return (_value == '1') ? Colors.blue : Colors.grey;
                      }),
                      onChanged: (value) {
                        setState(() {
                          _value = value.toString();
                        });
                      }),
                  Text(
                    'Video',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  Radio(
                      value: "2",
                      groupValue: _value,
                      activeColor: Colors.blue,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return (_value == '2') ? Colors.blue : Colors.grey;
                      }),
                      onChanged: (value) {
                        setState(() {
                          _value = value.toString();
                        });
                      }),
                ],
              ),
            ),
            _value == "0"
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ElevatedButton(
                            onPressed: () async {
                              AddPostUtil.addPost(
                                      url:
                                          Constants.baseUrl + Constants.addPost,
                                      token: Constants.token,
                                      content: _contentController.text)
                                  .then((value) async {
                                print("---------------");
                                print("The Value in Order Screen is: $value");
                                print("$value ");
                                print("---------------");
                                JsonDecoder _decoder = JsonDecoder();
                                final parsed = await _decoder.convert(value);

                                // TODO: replace strings with constants.

                                int status = parsed['status'];

                                if (status == 201) {
                                  String msg = parsed['message'];
                                  print(msg);
                                  Fluttertoast.showToast(
                                      msg: msg, toastLength: Toast.LENGTH_LONG);
                                  return;
                                }
                                if (status != '201') {
                                  String msg = parsed['message'];

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "Something wrong please check message: $msg"),
                                  ));
                                  return;
                                }
                                /*  startPayment();*/
                              });
                            },
                            child: Text(
                              'Add Post',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff1D436D)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  )
                : _value == "1"
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: MultiImagePickerView(
                                controller: controller,
                                padding: const EdgeInsets.all(10),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                onPressed: () async {
                                  List<String> imageUrls = [];
                                  List<String> tasksId = [];
                                  List<int> imageSizes = [];

                                  for (ImageFile asset in controller.images) {
                                    final byteData = asset.bytes;
                                    final imageSize = asset.size;

                                    final taskId = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                    tasksId.add(taskId);
                                    final ref = FirebaseStorage.instance
                                        .ref()
                                        .child('posts_images/$taskId.jpg');
                                    final uploadTask = ref.putData(
                                        byteData!,
                                        SettableMetadata(
                                            contentType: 'image/jpeg'));
                                    await uploadTask.whenComplete(() async {
                                      final downloadUrl =
                                          await ref.getDownloadURL();
                                      imageUrls.add(downloadUrl);
                                      imageSizes.add(imageSize);

                                      print(downloadUrl.toString());
                                    });
                                  }
                                  AddPostWithImageUtil.addImagePost(
                                          url: Constants.baseUrl +
                                              Constants.addPost,
                                          token: Constants.token,
                                          content: _contentController.text,
                                          imageUrls: imageUrls,
                                          idImages: tasksId,
                                          sizeImages: imageSizes)
                                      .then((value) async {
                                    print("---------------");
                                    print("The Value in Post is: $value");
                                    print("$value ");
                                    print("---------------");
                                    JsonDecoder _decoder = JsonDecoder();
                                    final parsed =
                                        await _decoder.convert(value);

                                    // TODO: replace strings with constants.

                                    int status = parsed['status'];

                                    if (status == 201) {
                                      String msg = parsed['message'];
                                      print(msg);
                                      Fluttertoast.showToast(
                                          msg: msg,
                                          toastLength: Toast.LENGTH_LONG);
                                      return;
                                    }
                                    if (status != '201') {
                                      String msg = parsed['message'];

                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            "Something wrong please check message: $msg"),
                                      ));
                                      return;
                                    }
                                    /*  startPayment();*/
                                  });
                                },
                                child: Text(
                                  'Add Post',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff1D436D)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            _videoFile != null
                                ? SizedBox(
                                    height: 200,
                                    child: VideoPlayer(
                                      videoFile: _videoFile!,
                                    ),
                                  )
                                : Container(),
                            ElevatedButton(
                              onPressed: _pickVideo,
                              child: Text('Select Video'),
                            ),
                            ElevatedButton(
                              onPressed: _uploadVideo,
                              child: Text('Upload Video'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _uploadMessage,
                              style: TextStyle(
                                color: _uploadMessage ==
                                        'Video uploaded successfully'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_videoUrl == '') {
                                    Fluttertoast.showToast(
                                        msg: 'Upload Video First');
                                  } else {
                                    AddPostWithVideoUtil.addVideoPost(
                                            url: Constants.baseUrl +
                                                Constants.addPost,
                                            token: Constants.token,
                                            content: _contentController.text,
                                            videoHeight: _videoHeight,
                                            videoSize: _videoSize,
                                            videoWidth: _videoWidth,
                                            videoUrl: _videoUrl)
                                        .then((value) async {
                                      print("---------------");
                                      print("The Value in Post is: $value");
                                      print("$value ");
                                      print("---------------");
                                      JsonDecoder _decoder = JsonDecoder();
                                      final parsed =
                                          await _decoder.convert(value);

                                      // TODO: replace strings with constants.

                                      int status = parsed['status'];

                                      if (status == 201) {
                                        String msg = parsed['message'];
                                        print(msg);
                                        Fluttertoast.showToast(
                                            msg: msg,
                                            toastLength: Toast.LENGTH_LONG);
                                        return;
                                      }
                                      if (status != '201') {
                                        String msg = parsed['message'];

                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              "Something wrong please check message: $msg"),
                                        ));
                                        return;
                                      }
                                      /*  startPayment();*/
                                    });
                                  }
                                },
                                child: Text(
                                  'Add Post',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff1D436D)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      )
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>> getVideoInfo(File videoFile) async {
    VideoPlayerController controller = VideoPlayerController.file(videoFile);
    await controller.initialize();

    int size = await videoFile.length();
    int width = controller.value.size.width.toInt();
    int height = controller.value.size.height.toInt();

    await controller.dispose();

    return {
      'size': size,
      'width': width,
      'height': height,
    };
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      Map<String, dynamic> videoInfo = await getVideoInfo(_videoFile!);
      int size = videoInfo['size'];
      int width = videoInfo['width'];
      int height = videoInfo['height'];

      setState(() {
        _videoSize = size.toString();
        _videoWidth = width.toString();
        _videoHeight = height.toString();
      });
    }

    if (_videoFile == null) {
      setState(() {
        _uploadMessage = 'No video selected';
      });
      return;
    }

    setState(() {
      _uploadMessage = 'Uploading...';
    });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('videos/$fileName.mp4');

    try {
      await ref.putFile(_videoFile!);
      String downloadURL = await ref.getDownloadURL();

      setState(() {
        _uploadMessage = 'Video uploaded successfully';
        _videoUrl = downloadURL;
      });

      print('Video uploaded successfully. Download URL: $downloadURL');
    } catch (e) {
      setState(() {
        _uploadMessage = 'Error uploading video';
      });
      print('Error uploading video: $e');
    }
  }
}

class VideoPlayer extends StatefulWidget {
  final File videoFile;

  const VideoPlayer({super.key, required this.videoFile});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.videoFile);

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
