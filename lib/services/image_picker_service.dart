import 'dart:io';

import 'package:firebase_realtime_chat/services/extention.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> pickImage(
    String collection, ImageSource source, int imageQuality) async {
  XFile? image = await ImagePicker().pickImage(source: source);
  if (image == null) {
    return "";
  }

  Reference ref = FirebaseStorage.instance
      .ref()
      .child("$collection/${DateTime.now().microsecondsSinceEpoch}");
  UploadTask uploadTask = ref.putFile(File(image.path));

  try {
    await uploadTask;
    String? profile = await ref.getDownloadURL();
    return profile;
  } catch (e) {
    return handleFirebaseStorageError(e);
  }
}

Future<String> postImageOnFirebase(collection, File file) async {
  Reference ref = FirebaseStorage.instance
      .ref()
      .child(collection + "/${DateTime.now().microsecondsSinceEpoch}");
  UploadTask uploadTask = ref.putFile(file);

  try {
    await uploadTask;
    String? profile = await ref.getDownloadURL();
    return profile;
  } catch (e) {
    return handleFirebaseStorageError(e);
  }
}
