class Restaurant {
  final String name;
  final String address;
  final String distance;
  final Uri placeUrl;

  Restaurant(
      {required this.name,
      required this.address,
      required this.distance,
      required this.placeUrl});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['place_name'],
      address: json['address_name'],
      distance: json['distance'],
      placeUrl: Uri.parse(json['place_url']),
    );
  }
}
