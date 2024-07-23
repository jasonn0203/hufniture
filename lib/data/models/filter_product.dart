class FilterProduct {
  late List<FilterProductList> results;

  FilterProduct({required this.results});

  FilterProduct.fromJson(Map<String, dynamic> json) {
    results = (json["results"] == null
        ? null
        : (json["results"] as List)
            .map((e) => FilterProductList.fromJson(e))
            .toList())!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["results"] = results.map((e) => e.toJson()).toList();
    return _data;
  }
}

class FilterProductList {
  late String id;
  late String name;
  late String description;
  late String imageUrl;
  late double price;
  late String colorId;
  late String furnitureCategoryId;
  late String furnitureTypeId;

  FilterProductList(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.colorId,
      required this.furnitureCategoryId,
      required this.furnitureTypeId});

  FilterProductList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    imageUrl = json["imageURL"];
    price = json["price"];
    colorId = json["colorId"];
    furnitureCategoryId = json["furnitureCategoryId"];
    furnitureTypeId = json["furnitureTypeId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["imageURL"] = imageUrl;
    _data["price"] = price;
    _data["colorId"] = colorId;
    _data["furnitureCategoryId"] = furnitureCategoryId;
    _data["furnitureTypeId"] = furnitureTypeId;
    return _data;
  }
}
