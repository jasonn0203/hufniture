class ReviewResponse {
  final String id;
  final String furnitureProductId;
  final String userId;
  final String content;
  final String createdAt;
  final String userFullName;

  ReviewResponse({
    required this.id,
    required this.furnitureProductId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.userFullName,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      id: json['id'] ?? '',
      furnitureProductId: json['furnitureProductId'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      userFullName: json['userFullName'] ?? '',
    );
  }
}
