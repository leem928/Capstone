class Place {
  final String id;
  final String name;
  final String address;
  final String roadAddress;
  final String phone;
  final String placeUrl;
  final String distance;
  final double longitude;
  final double latitude;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.roadAddress,
    required this.phone,
    required this.placeUrl,
    required this.distance,
    required this.longitude,
    required this.latitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id']?.toString() ?? '',
      name: json['place_name']?.toString() ?? '',
      address: json['address_name']?.toString() ?? '',
      roadAddress: json['road_address_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      placeUrl: json['place_url']?.toString() ?? '',
      distance: json['distance']?.toString() ?? '',
      longitude: double.tryParse(json['x']?.toString() ?? '0') ?? 0,
      latitude: double.tryParse(json['y']?.toString() ?? '0') ?? 0,
    );
  }
}