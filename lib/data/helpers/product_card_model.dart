class ProductCardModel {
  final int id;
  final String prodName;
  final String prodImgUrl;
  final String shorDesc;
  final double prodPrice;

  ProductCardModel(
      {required this.id,
      required this.prodImgUrl,
      required this.prodName,
      required this.shorDesc,
      required this.prodPrice});
}
