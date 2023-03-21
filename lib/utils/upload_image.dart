import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

typedef ImageId = String;
Future<ImageId?> uploadImage({
  required File file,
  required String userId,
  required String imageId,
}) =>
    FirebaseStorage.instance
        .ref(userId)
        .child(imageId)
        .putFile(file)
        .then<ImageId?>((_) => imageId)
        .catchError((_) => null);
