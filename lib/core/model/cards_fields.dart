// Model for cards fields
class CardsFields {
  static const String id = 'Card ID';
  static const String word = 'Word';
  static const String translation = 'Translation';
  static const String image_id = 'Image ID';

  static List<String> getFields() => [id, word, translation, image_id];
}