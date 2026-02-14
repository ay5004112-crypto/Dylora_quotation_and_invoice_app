class BusinessProfile {
  final String name;
  final String address;
  final String email;
  final String phone;
  final String gst;

  final String accountName;
  final String accountNumber;
  final String ifsc;
  final String bankName;
  final String? logoPath;
  final String? qrPath;
  final String? stampPath;
  final String? signaturePath;

  BusinessProfile({
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.gst,
    required this.accountName,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    this.logoPath,
    this.qrPath,
    this.stampPath,
    this.signaturePath,
  });
}
