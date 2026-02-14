class Item {
  String name;
  double quantity;
  double rate;

  Item({required this.name, required this.quantity, required this.rate});

  double get total => quantity * rate;
}