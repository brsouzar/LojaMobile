class ProductData{
  String? id;
  String? category;

  String? title;
  String? description;
  double? price;

  List? images;
  List? sizes;

  ProductData.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    price = data['price'] + 0.0;
    images = data['images'];
    sizes = data['sizes'];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      'title': title,
      'descripton': description,
      'price': price,
    };
  }
}