class CategoryProductWithType {
  CategoryProductWithTypeList? results;

  CategoryProductWithType({this.results});

  CategoryProductWithType.fromJson(Map<String, dynamic> json) {
    results = json['results'] != null
        ? CategoryProductWithTypeList.fromJson(json['results'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class CategoryProductWithTypeList {
  String? categoryName;
  List<FurnitureTypes>? furnitureTypes;

  CategoryProductWithTypeList({this.categoryName, this.furnitureTypes});

  CategoryProductWithTypeList.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    if (json['furnitureTypes'] != null) {
      furnitureTypes = <FurnitureTypes>[];
      json['furnitureTypes'].forEach((v) {
        furnitureTypes!.add(new FurnitureTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryName'] = this.categoryName;
    if (this.furnitureTypes != null) {
      data['furnitureTypes'] =
          this.furnitureTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FurnitureTypes {
  String? typeName;
  List<Products>? products;

  FurnitureTypes({this.typeName, this.products});

  FurnitureTypes.fromJson(Map<String, dynamic> json) {
    typeName = json['typeName'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeName'] = this.typeName;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  late String id;
  late String name; // Marked as late to delay initialization
  late String description; // Marked as late to delay initialization
  late String imageURL; // Marked as late to delay initialization
  late double price; // Marked as late to delay initialization
  String? colorId;
  String? furnitureCategoryId;
  String? furnitureTypeId;

  Products({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.price,
    this.colorId,
    this.furnitureCategoryId,
    this.furnitureTypeId,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? ''; // Provide default value if null
    description = json['description'] ?? ''; // Provide default value if null
    imageURL = json['imageURL'] ?? ''; // Provide default value if null
    price = json['price'] ?? 0; // Provide default value if null
    colorId = json['colorId'];
    furnitureCategoryId = json['furnitureCategoryId'];
    furnitureTypeId = json['furnitureTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['imageURL'] = imageURL;
    data['price'] = price;
    if (colorId != null) data['colorId'] = colorId;
    if (furnitureCategoryId != null)
      data['furnitureCategoryId'] = furnitureCategoryId;
    if (furnitureTypeId != null) data['furnitureTypeId'] = furnitureTypeId;
    return data;
  }
}
