class CountryModel {
  final String id;
  final String country;
  final String flag;
  final String createdAt;

  CountryModel({
    required this.id,
    required this.country,
    required this.flag,
    required this.createdAt,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      country: json['country'],
      flag: json['flag'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'flag': flag,
      'createdAt': createdAt,
    };
  }
}