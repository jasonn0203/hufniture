class ProductResponse {
  ProductResults? results;

  ProductResponse({this.results});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    results = json["results"] == null
        ? null
        : ProductResults.fromJson(json["results"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (results != null) {
      _data["results"] = results?.toJson();
    }
    return _data;
  }
}

class ProductResults {
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  double? price;
  String? colorId;
  dynamic color;
  String? furnitureCategoryId;
  dynamic furnitureCategory;
  String? furnitureTypeId;
  dynamic furnitureType;
  dynamic reviews;

  ProductResults(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.price,
      this.colorId,
      this.color,
      this.furnitureCategoryId,
      this.furnitureCategory,
      this.furnitureTypeId,
      this.furnitureType,
      this.reviews});

  ProductResults.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    imageUrl = json["imageURL"];
    price = json["price"];
    colorId = json["colorId"];
    color = json["color"];
    furnitureCategoryId = json["furnitureCategoryId"];
    furnitureCategory = json["furnitureCategory"];
    furnitureTypeId = json["furnitureTypeId"];
    furnitureType = json["furnitureType"];
    reviews = json["reviews"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["imageURL"] = imageUrl;
    _data["price"] = price;
    _data["colorId"] = colorId;
    _data["color"] = color;
    _data["furnitureCategoryId"] = furnitureCategoryId;
    _data["furnitureCategory"] = furnitureCategory;
    _data["furnitureTypeId"] = furnitureTypeId;
    _data["furnitureType"] = furnitureType;
    _data["reviews"] = reviews;
    return _data;
  }
}
