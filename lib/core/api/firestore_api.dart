import 'package:firebase_storage/firebase_storage.dart';

import '../model/i_image_storage.dart';

class FirestoreAPI implements IImageStorage {
  @override
  Future<String> getImageUrl(String imageId) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('$imageId.png');
      return await ref.getDownloadURL();
    } catch (e) {
      return '';
    }
  }
}
