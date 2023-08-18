import 'dart:io';

import 'package:firebase_asif_taj_tutorials/ui/widgets/round_button.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;

  // final picker = ImagePicker();

  // FirebaseStorage storage = FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  // final fireStore = FirebaseFirestore.instance.collection('users');

  Future getGalleryImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        debugPrint('Image picked');
      } else {
        debugPrint('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: _image != null
                      ? Center(child: Image.file(_image!.absolute))
                      : const Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              loading: loading,
              title: 'Upload',
              onTap: () async {
                final String id =
                    DateTime.now().millisecondsSinceEpoch.toString();
                Reference firebaseStorageRef =
                    FirebaseStorage.instance.ref('/userImages/$id');
                TaskSnapshot uploadTaskStorage =
                    await firebaseStorageRef.putFile(_image!.absolute);
                // UploadTask uploadTaskStorage =
                //     firebaseStorageRef.putFile(_image!.absolute);
                var newUrl = await firebaseStorageRef.getDownloadURL();
                await Future.value(uploadTaskStorage).then((value) {
                  setState(() {
                    loading = true;
                  });
                  databaseRef.child(id).set({
                    // fireStore.doc(id).set({
                    'id': id,
                    'title': newUrl.toString(),
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().showToastMessage('Image uploaded successfully');
                  }).onError((error, stackTrace) {
                    Utils().showToastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }).onError((error, stackTrace) {
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
