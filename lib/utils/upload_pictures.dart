import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadaFile(String filePath, String fileName) async {
    try {
      await storage.ref('doctor_pictures/$fileName').putFile(File(filePath));
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('doctor_pictures/$imageName').getDownloadURL();

    return downloadURL;
  }
}