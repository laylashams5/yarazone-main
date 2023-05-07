
class Carousel {
  Carousel({
    this.title,
    this.subtitle,
    this.btn_label,
    this.btn_link,
    required this.image,
  });
  final String? title;
  final String? subtitle;
  final String? btn_label;
  final String? btn_link;
  final String image;

  factory Carousel.fromJson(Map<String, dynamic> json) => Carousel(
    title: json["title"],
    subtitle: json["subtitle"],
    btn_label: json["btn_label"],
    btn_link: json["btn_link"],
    image: json["image"] ,
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "btn_label": btn_label,
    "btn_link": btn_link,
    "image": image,
  };
}