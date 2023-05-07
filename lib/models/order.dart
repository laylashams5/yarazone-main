import 'package:yarazon/models/product.dart';

class Order {
  final int id;
  final int refrence_number;
  final String address;
  final int products_count;
  final String status;
  final String city;
  final String paid;
  final String remaining;
  final String total;
  final String total_after_discount;
  final String discount;
  final Product prodxes;
  Order(
      {required this.id,
      required this.refrence_number,
      required this.address,
      required this.products_count,
      required this.status,
      required this.city,
      required this.paid,
      required this.remaining,
      required this.total,
      required this.total_after_discount,
      required this.discount,
      required this.prodxes});
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      refrence_number: json["refrence_number"],
      address: json["email"],
      products_count: json["products_count"],
      status: json["status"],
      city: json["city"],
      paid: json["paid"],
      remaining: json["remaining"],
      total: json["total"],
      total_after_discount: json["total_after_discount"],
      discount: json["discount"],
      prodxes: Product.fromJson(json["prodxes"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "refrence_number": refrence_number,
        "address": address,
        "products_count": products_count,
        "status": status,
        "city": city,
        "paid": paid,
        "remaining": remaining,
        "total": total,
        "total_after_discount": total_after_discount,
        "discount": discount,
        "prodxes": prodxes.toJson()
      };
}
