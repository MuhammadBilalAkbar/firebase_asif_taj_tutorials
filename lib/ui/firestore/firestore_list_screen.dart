import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_asif_taj_tutorials/posts/add_post.dart';
import 'package:firebase_asif_taj_tutorials/ui/auth/login_screen.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'add_firestore_data.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final FirebaseAuth _logOutAuth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStoreSnapshots = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference fireStoreCollectionRef = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Firestore Post'),
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
              debugPrint('Signing out user ${_logOutAuth.currentUser!.email}');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
              stream: fireStoreSnapshots,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if (snapshot.hasError) return Text('Some error');
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final title = snapshot.data!.docs[index]['title'];
                        final id = snapshot.data!.docs[index]['id'];
                        return ListTile(
                          // onTap: () {
                          // },
                          title: Text(title),
                          subtitle: Text(id),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) {
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
                                    leading: Icon(Icons.edit),
                                    title: Text('Delete'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDeleteDialog(id);
                                    },
                                  ),
                                ),
                              ];
                            },
                          ),
                        );
                      }),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFirestoreDataScreen(),
            ),
          );
          debugPrint(
              '===================================================Navigating to add_firestore_data.dart');
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
                fireStoreCollectionRef.doc(id).update({
                  'title' : editController.text.toLowerCase(),
                }).then((value) {
                  Utils().showToastMessage('Firebase Firestore Post updated successfully');
                }).onError((error, stackTrace) {
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
          title: Text('Do you want to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                fireStoreCollectionRef.doc(id).delete().then((value) {
                  Utils().showToastMessage('Firebase Firestore Post deleted successfully');
                }).onError((error, stackTrace) {
                  Utils().showToastMessage(error.toString());
                });
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

}
