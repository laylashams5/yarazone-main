class Category {
  final int? id;
  final String name;
  final String? short_description;
  final String featured_image;
  final String slug;
  final String? parent_id;
  final  products;
  Category(
      {required this.id,
      required this.name,
      this.short_description="",
      required this.featured_image,
      this.slug = '',
      this.parent_id = null,
      this.products});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json["id"],
        name: json["name"],
        short_description: json["short_description"],
        featured_image: json["featured_image"],
        slug: json["slug"],
        parent_id: json["parent_id"],
        products: json["products"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_description": short_description,
        "featured_image": featured_image,
        "slug": slug,
        "parent_id": parent_id,
        "products": products == null
            ? null
            : List<dynamic>.from(products!.map((x) => x.toJson()))
      };
}
