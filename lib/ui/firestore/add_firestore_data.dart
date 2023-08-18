import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_asif_taj_tutorials/ui/widgets/round_button.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');

  // final fireStore = FirebaseFirestore.instance.collection('asif');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              loading: loading,
              title: 'Add',
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': postController.text,
                  'id': id,
                }).then((value) {
                  debugPrint('Firebase Firestore Data added successfully');
                  setState(() {
                    loading = false;
                  });
                  Utils().showToastMessage(
                      'Firebase Firestore Post Added Successfully');
                }).onError((error, stackTrace) {
                  debugPrint(error.toString());
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
