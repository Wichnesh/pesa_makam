class PurchaseModel {
  String? vendorName;
  String? amount;
  String? taxPercentage;
  String? taxAmount;
  String? totalAmount;
  String? payment;
  String? orderDate;
  String? pendingDate;

  PurchaseModel({
    this.vendorName,
    this.amount,
    this.taxPercentage,
    this.taxAmount,
    this.totalAmount,
    this.payment,
    this.orderDate,
    this.pendingDate,
  });
}

class FilterPurchaseModel {
  String? id;
  String? vendorName;
  String? amount;
  String? taxPercentage;
  String? taxAmount;
  String? totalAmount;
  String? payment;
  String? orderDate;
  String? pendingDate;

  FilterPurchaseModel({
    this.id,
    this.vendorName,
    this.amount,
    this.taxPercentage,
    this.taxAmount,
    this.totalAmount,
    this.payment,
    this.orderDate,
    this.pendingDate,
  });
}
