class Department {
  int id;
  String name_ar;
  String name_en;

  Department({required this.id,required this.name_ar,required this.name_en});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(id: json['id'],name_ar: json['name_ar'],name_en: json['name_en']);
  }
}