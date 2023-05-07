class CartItem {
  final int id;
  final String cart_id;
  final String product_id;
  final String product_name;
  final String product_slug;
  final String? price_aed;
  final int price_sdg;
  final String featured_image;
  final String qty;
  final String created_at;
  CartItem({
    required this.id,
    required this.cart_id,
    required this.product_id,
    required this.product_name,
    required this.product_slug,
    this.price_aed,
    required this.price_sdg,
    required this.featured_image,
    required this.qty,
    required this.created_at,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json["id"],
      cart_id: json["cart_id"],
      product_id: json["product_id"],
      product_name: json["product_name"],
      product_slug: json["product_slug"],
      price_aed: json["price_aed"],
      price_sdg: json["price_sdg"],
      featured_image: json["featured_image"],
      qty: json["qty"],
      created_at: json["created_at"],
    );
  }
}
