class ContactLinks {
  final String facebook;
  final String twitter;
  final String instagram;
  final String linkedin;
  final String youtube;
  final String tiktok;
  final String whatsapp;
  final String telegram;

  ContactLinks(
      {this.facebook = '',
      this.twitter = '',
      this.instagram = '',
      this.linkedin = '',
      this.youtube = '',
      this.tiktok = '',
      this.whatsapp = '',
      this.telegram = '',});

  factory ContactLinks.fromJson(Map<String, dynamic> json) {
    return ContactLinks(
        facebook: json["facebook"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        youtube: json["youtube"],
        tiktok: json["tiktok"],
        whatsapp: json["whatsapp"],
        telegram: json["telegram"],);
  }
  Map<String, dynamic> toJson() => {
        "facebook": facebook,
        "twitter": twitter,
        "instagram": instagram,
        "linkedin": linkedin,
        "youtube": youtube,
        "tiktok": tiktok,
        "whatsapp": whatsapp,
        "telegram": telegram
      };
}
