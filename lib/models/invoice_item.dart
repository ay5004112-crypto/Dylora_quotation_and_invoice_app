class InvoiceItem {
  String name;
  int quantity;
  double price;

  InvoiceItem({
    required this.name,
    this.quantity = 1,
    this.price = 0.0,
  });

  // Automatic calculation of item total
  double get total => quantity * price;
}