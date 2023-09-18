class CategoryDetail {
  late final String name;
  final String description;
  final String price;
  final String image;

  CategoryDetail({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}

class forPosTicketDetail {
  String? name;
  String? description;
  String? price;
  String? image;
  int? itemcount;
  forPosTicketDetail({
    this.name,
    this.description,
    this.price,
    this.image,
    this.itemcount,
  });
}

class Bill {
  final String date;
  final String totalAmount;
  final List<forPosTicketDetail> items;

  Bill({
    required this.date,
    required this.totalAmount,
    required this.items,
  });
}

class FilterBill {
  String? id;
  String? date;
  String? totalAmount;
  List<forPosTicketDetail>? items;

  FilterBill({
    this.id,
    this.date,
    this.totalAmount,
    this.items,
  });
}
