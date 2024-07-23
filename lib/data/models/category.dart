// ignore_for_file: unnecessary_this, prefer_collection_literals

class FurnitureCategory {
  List<FurnitureCategoryList>? results;

  FurnitureCategory({this.results});

  FurnitureCategory.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <FurnitureCategoryList>[];
      json['results'].forEach((v) {
        results!.add(FurnitureCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FurnitureCategoryList {
  String? id;
  late String name;
  String? categoryIcon;
  Null? furnitureProducts;
  Null? furnitureTypes;

  FurnitureCategoryList(
      {this.id,
      required this.name,
      this.categoryIcon,
      this.furnitureProducts,
      this.furnitureTypes});

  FurnitureCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryIcon = json['categoryIcon'];
    furnitureProducts = json['furnitureProducts'];
    furnitureTypes = json['furnitureTypes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['categoryIcon'] = this.categoryIcon;
    data['furnitureProducts'] = this.furnitureProducts;
    data['furnitureTypes'] = this.furnitureTypes;
    return data;
  }
}
