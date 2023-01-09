import 'package:firebase_asif_taj_tutorials/ui/widgets/round_button.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final _setPostDatabaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firebase Realtime Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            RoundButton(
              loading: loading,
              title: 'Add',
              onTap: () {
                setState(() {
                  loading = true;
                });
                final String id =
                    DateTime.now().millisecondsSinceEpoch.toString();
                // databaseRef.child('asif').set(
                _setPostDatabaseRef.child(id).set(
                  {
                    'id': id,
                    'title': postController.text,
                  },
                ).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().showToastMessage('Post Added');
                  debugPrint(
                      '-------------------------------------------post added in add_post.dart firebase realtime database');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().showToastMessage(error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
