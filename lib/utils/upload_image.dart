import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<bool> uploadImage({required File file, required String userId}) async {
  try {
    await FirebaseStorage.instance
        .ref(userId)
        .child(const Uuid().v4())
        .putFile(file);
    return true;
  }catch (e){
    return false;
  }

}
