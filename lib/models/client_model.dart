class Client {
  String name;
  String address;
  String email;
  String phone;
  String? gstNumber;

  Client({
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    this.gstNumber,
  });
}