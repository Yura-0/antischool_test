import 'package:firebase_storage/firebase_storage.dart';

class FirestoreAPI {
  Future<String> getImageUrl(String imageId) async {
    final ref = FirebaseStorage.instance.ref().child('$imageId.png');
    return await ref.getDownloadURL();
  }
}

