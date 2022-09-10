import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/models/post.dart';
import 'package:firebase/providers/crud_provider.dart';
import 'package:firebase/screens/detail_page.dart';
import 'package:firebase/screens/details_screen.dart';
import 'package:firebase/screens/messagepage.dart';
import 'package:firebase/widgets/edit_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../models/user.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final uid = auth.FirebaseAuth.instance.currentUser!.uid;

  late User user;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sumlike;
    return Consumer(
      builder: (context, ref, child) {
        final postStream = ref.watch(postProvider);
        final userStream = ref.watch(userProvider);
        return SafeArea(
            child: Scaffold(
          body: NestedScrollView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  snap: true,
                  floating: true,
                  backgroundColor: Colors.white,

                  title: GradientText(
                    'DMT',
                    style: TextStyle(fontSize: 30),
                    colors: [
                      const Color(0xffE5E3C9),
                      const Color(0xffB4CFB0),
                      const Color(0xff94B49F),
                      const Color(0xff789395),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Get.to(() => messagepage(),
                              transition: Transition.zoom);
                        },
                        icon: Icon(
                          Icons.message,
                          color: Color(0xff94B49F),
                          size: 30,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                  // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
                ),
              ];
            },
            key: _globalKey,
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffE5E3C9),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    height: 108,
                    child: userStream.when(
                        data: (data) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: ((context, index) {
                                  user = data.firstWhere(
                                      (element) => element.userId == uid);
                                  final dat = data[index];
                                  return Container(
                                    decoration: BoxDecoration(),
                                    margin: EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: (() {
                                        Get.to(
                                            () => details_screen(
                                                  user: dat,
                                                  name: dat.username,
                                                  clickedid: dat.userId,
                                                ),
                                            transition: Transition.fade);
                                      }),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 33,
                                            backgroundImage:
                                                NetworkImage(dat.userImage),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            dat.username,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                          );
                        },
                        error: (err, stack) => Text("$err"),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink,
                              ),
                            )),
                  ),
                  Expanded(
                    child: Container(
                      child: postStream.when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final dat = data[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage:
                                                      NetworkImage(dat.whose),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  dat.whosename,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    print('Checked');
                                                  },
                                                  icon: FaIcon(
                                                    FontAwesomeIcons
                                                        .userAstronaut,
                                                    size: 25,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                if (uid == dat.userId)
                                                  IconButton(
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                          title:
                                                              "Update Or Remove Post",
                                                          content: Text(
                                                              'Customize Post'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Get.to(
                                                                      () => EditPage(
                                                                          dat),
                                                                      transition:
                                                                          Transition
                                                                              .leftToRight);
                                                                },
                                                                child: Icon(
                                                                  Icons.edit,
                                                                  color: Color(
                                                                      0xffB4CFB0),
                                                                )),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  await ref
                                                                      .read(
                                                                          crudProvider)
                                                                      .postRemove(
                                                                          postId: dat
                                                                              .id,
                                                                          imageId:
                                                                              dat.imageId);
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Color(
                                                                      0xffB4CFB0),
                                                                )),
                                                          ]);
                                                      // Get.to(() => EditPage(dat));
                                                    },
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Card(
                                          elevation: 10,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 400,
                                                  width: double.infinity,
                                                  child: InkWell(
                                                    onLongPress: () {
                                                      Get.defaultDialog(
                                                          title:
                                                              "Download Post??",
                                                          content: Text(
                                                              "Click on Download !!!!"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Icon(
                                                                  Icons.cancel,
                                                                  color: Color(
                                                                      0xffB4CFB0),
                                                                )),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  ref
                                                                      .watch(
                                                                          crudProvider)
                                                                      .Download(
                                                                          dat.userImage,
                                                                          dat.title);

                                                                  GFToast
                                                                      .showToast(
                                                                    '${dat.title} has been Downloaded to Download Folder ✌🏻',
                                                                    context,
                                                                    toastPosition:
                                                                        GFToastPosition
                                                                            .BOTTOM,
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: GFColors
                                                                          .DARK,
                                                                    ),
                                                                    backgroundColor:
                                                                        GFColors
                                                                            .LIGHT,
                                                                  );

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .download,
                                                                  color: Color(
                                                                      0xffB4CFB0),
                                                                )),
                                                          ]);
                                                    },
                                                    onTap: () {
                                                      Get.to(
                                                          () => DetailPage(
                                                                post: dat,
                                                                user: user,
                                                              ),
                                                          transition: Transition
                                                              .leftToRight);
                                                    },
                                                    child: CachedNetworkImage(
                                                      placeholder:
                                                          (context, String) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.pink,
                                                          ),
                                                        );
                                                      },
                                                      imageUrl: dat.userImage,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // if (dat.userId != uid)

                                                  IconButton(
                                                      onPressed: () {
                                                        if (dat
                                                            .likeData.usernames
                                                            .contains(user
                                                                .username)) {
                                                          GFToast.showToast(
                                                            'Thanks for Response ✌🏻',
                                                            context,
                                                            toastPosition:
                                                                GFToastPosition
                                                                    .BOTTOM,
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  GFColors.DARK,
                                                            ),
                                                            backgroundColor:
                                                                GFColors.LIGHT,
                                                          );
                                                        } else {
                                                          final likes = Like(
                                                              like: dat.likeData
                                                                      .like +
                                                                  1,
                                                              usernames: [
                                                                ...dat.likeData
                                                                    .usernames,
                                                                user.username
                                                              ]);
                                                          int sumlike = likes
                                                              .like.bitLength;

                                                          ref
                                                              .read(
                                                                  crudProvider)
                                                              .addlike(likes,
                                                                  dat.id);
                                                        }
                                                      },
                                                      icon:
                                                          Icon(Icons.thumb_up)),
                                                  if (dat.likeData.like != 0)
                                                    Text(
                                                        "${dat.likeData.like}"),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          error: (err, stack) => Text("$err"),
                          loading: () => Container()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));

        // drawer: DrawerWidget(),
      },
    );
  }
}
