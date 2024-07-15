class Restaurant {
  final String name;
  final String categoryName;
  final String distance;
  final Uri placeUrl;

  Restaurant(
      {required this.name,
      required this.categoryName,
      required this.distance,
      required this.placeUrl});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['place_name'],
      categoryName: json['category_name'],
      distance: json['distance'],
      placeUrl: Uri.parse(json['place_url']),
    );
  }
}
