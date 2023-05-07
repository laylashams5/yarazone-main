
class Product {
  final int id;
  final bool is_fav;
  final bool in_cart;
  final String name;
  final String? specs;
  final String featured_image;
  final String price_sdg;
  final String? new_price_sdg;
  final String? weight;
  final String? length;
  final String? height;
  final String? slug;
  final Map<String,dynamic>? category;
  final  Map<String,dynamic>? brand;
  Product(
      {this.id=0,
      this.is_fav = false,
      this.in_cart = false,
      this.name='',
      this.specs = '',
      this.featured_image = '',
      required this.price_sdg,
      this.new_price_sdg = null,
      this.weight = '',
      this.length = '',
      this.height = '',
      this.slug = '',
      this.category = null,
      this.brand = null});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      is_fav: json["is_fav"],
      in_cart: json["in_cart"],
      name: json["name"],
      specs: json["specs"],
      featured_image: json["featured_image"],
      price_sdg: json["price_sdg"],
      new_price_sdg: json["new_price_sdg"],
      weight: json["weight "],
      length: json["length "],
      height: json["height "],
      slug: json["slug "],
      category: json["category"],
      brand: json["brand"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "is_fav": is_fav,
        "in_cart": in_cart,
        "name": name,
        "specs": specs,
        "featured_image": featured_image,
        "price_sdg": price_sdg,
        "new_price_sdg": new_price_sdg,
        "weight": weight,
        "length": length,
        "height": height,
        "slug": slug,
        "category": category,
        "brand": brand,
      };
}
