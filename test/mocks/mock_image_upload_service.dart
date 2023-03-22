import 'package:reminders_mobx/services/image_upload_service.dart';

class MockImageUploadService implements ImageUploadService {
  @override
  Future<ImageId?> uploadImage({
    required String filePath,
    required String userId,
    required String imageId,
  }) async =>
      'mock_image_id';
}
