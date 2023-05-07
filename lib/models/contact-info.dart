class ContactInfo {
  final String address;
  final String phone;
  final String email;
  ContactInfo(
      {this.address = '',
      this.phone = '',
      this.email = '',});

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
        address: json["address"],
        email: json["email"],
        phone: json["phone"],);
  }
  Map<String, dynamic> toJson() => {
        "address": address,
        "email": email,
        "phone": phone,
      };
}
