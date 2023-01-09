import 'package:firebase_asif_taj_tutorials/posts/add_post.dart';
import 'package:firebase_asif_taj_tutorials/ui/auth/login_screen.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth _logOutAuth = FirebaseAuth.instance;
  final _getPostDatabaseRef = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //     super.initState();
  //
  //     _getPostDatabaseRef.onValue.listen((event) {
  //
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts of Realtime Database'),
        actions: [
          IconButton(
            onPressed: () {
              _logOutAuth.signOut().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
                debugPrint(
                    '===================================================Navigating to login_screen.dart');
              }).onError((error, stackTrace) {
                Utils().showToastMessage(error.toString());
              });
              debugPrint('Signing out user ${_logOutAuth.currentUser!.email}\n${_logOutAuth.currentUser!.emailVerified}\n${_logOutAuth.currentUser}');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: StreamBuilder(
          //     stream: _getPostDatabaseRef.onValue,
          //     builder: (BuildContext context,
          //         AsyncSnapshot<DatabaseEvent> snapshot) {
          //       if (!snapshot.hasData) {
          //         return CircularProgressIndicator();
          //       } else {
          //         Map<dynamic, dynamic> map =
          //             snapshot.data!.snapshot.value as dynamic;
          //         List<dynamic> list = [];
          //         list.clear();
          //         list = map.values.toList();
          //         return ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return ListTile(
          //               title: Text(list[index]['title']),
          //               subtitle: Text(list[index]['id']),
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Center(child: Text('Loading')),
              query: _getPostDatabaseRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  animation, index) {
                final title = snapshot.child('title').value.toString();
                final id = snapshot.child('id').value.toString();
                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(title),
                    subtitle: Text(id),
                    trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showEditDialog(title, id);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  // _getPostDatabaseRef.child(id).remove();
                                  showDeleteDialog(id);
                                },
                              ),
                            ),
                          ];
                        }),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase().toString())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostScreen(),
            ),
          );
          debugPrint(
              '===================================================Navigating to add_post.dart');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showEditDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: 'Edit',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _getPostDatabaseRef
                    .child(id)
                    .update({'title': editController.text.toLowerCase()})
                    .then((value) {
                  Utils().showToastMessage('Post updated successfully');
                })
                    .onError((error, stackTrace) {
                      Utils().showToastMessage(error.toString());
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }







  Future<void> showDeleteDialog(String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _getPostDatabaseRef
                    .child(id)
                    .remove()
                    .then((value) {
                  Utils().showToastMessage('Post deleted successfully');
                })
                    .onError((error, stackTrace) {
                  Utils().showToastMessage(error.toString());
                });
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }
}
