class Client {
  String id; // Added for easier editing/deleting
  String name;
  String address;
  String cityStateCountry;
  String phone;
  String? email; // Optional
  String? gst;   // Optional

  Client({
    required this.id,
    required this.name,
    required this.address,
    required this.cityStateCountry,
    required this.phone,
    this.email,
    this.gst,
  });
}