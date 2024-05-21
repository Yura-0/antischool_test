// Model for image storage
abstract class IImageStorage {
  Future<String> getImageUrl(String imageId);
}
