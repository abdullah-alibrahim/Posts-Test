import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posts_test/controllers/post.dart';
import 'package:posts_test/view/newPost.dart';
import 'package:posts_test/widgets/post_widgets.dart' as p;
import 'package:posts_test/widgets/ShimmerWidget.dart' as sh ;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final scrollController = ScrollController();
  int page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const NewPost()),
        child: const Icon(Icons.post_add),
      ),
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: Container(
          child: GetBuilder<PostController>(
        init: PostController(),
        builder: (postController) => FutureBuilder(
            future: postController.fetchPosts('$page', ''),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Container(
                  height: height,
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  // color: Colors.lightBlue.shade50,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) => sh.ShimmerWidget(height: height, width: width),
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else if (snapshot.data == null) {
                return const Expanded(
                  child: Text('null'),
                );
              }
              return snapshot.connectionState == ConnectionState.done
                  ? ListView.builder(
                      padding:EdgeInsets.only(top: 15,bottom: 15) ,
                      controller: scrollController,
                      itemCount: postController.getPosts.length,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Text(postController.getPosts[index].content),
                          child: p.postWidget(postController.getPosts[index]),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator());
            })),
      )),
    );
  }

  void _scrollListener() {
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
      print('Scroll Listener Called');
      setState(() {
        page = page +1;
      });
    }else {
      print('Scroll Listener Not Called');

    }
  }
}

