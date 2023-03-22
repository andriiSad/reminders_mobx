import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

typedef ImageId = String;

abstract class ImageUploadService {
  Future<ImageId?> uploadImage({
    required String filePath,
    required String userId,
    required String imageId,
  });
}

class FirebaseImageUploadService implements ImageUploadService {
  @override
  Future<ImageId?> uploadImage({
    required String filePath,
    required String userId,
    required String imageId,
  }) =>
      FirebaseStorage.instance
          .ref(userId)
          .child(imageId)
          .putFile(File(filePath))
          .then<ImageId?>((_) => imageId)
          .catchError((_) => null);
}
