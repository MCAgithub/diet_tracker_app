class Food {
  String id;
  String uploader;
  String name;
  int kcal;

  double? protein;
  double? carbohydrates;
  double? fat;

  double? salt;

  double? carbohydratessugar;
  double? fatsaturated;

  String? pictureurl;
  String? shop;

  int? totalgraminpackage;
  int? totalitemsinpackage;

  int? barcode;

  Food({
    this.id = '',
    required this.uploader,
    required this.name,
    required this.kcal,
    this.fat,
    this.fatsaturated,
    this.carbohydrates,
    this.carbohydratessugar,
    this.protein,
    this.salt,
    this.pictureurl,
    // Misc
    this.totalgraminpackage,
    this.totalitemsinpackage,
    this.shop,
    this.barcode
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uploader': uploader,
        'name': name,
        'kcal': kcal,
        'protein': protein,
        'carbohydrates': carbohydrates,
        'fat': fat,
        'carbohydratessugar': carbohydratessugar,
        'fatsaturated': fatsaturated,
        'salt' : salt,
        'pictureurl': pictureurl,
        // Misc info
        'totalgraminpackage': totalgraminpackage,
        'totalitemsinpackage': totalitemsinpackage,
        'shop': shop,
        'barcode' : barcode
      };

  static Food fromJson(Map<String, dynamic> json) => Food(
        id: json['id'],
        uploader: json['uploader'],
        name: json['name'],
        kcal: json['kcal'],
        protein: json['protein'],
        carbohydrates: json['carbohydrates'],
        fat: json['fat'],
        carbohydratessugar: json['carbohydratessugar'],
        fatsaturated: json['fatsaturated'],
        salt : json['salt'],
        pictureurl: json['pictureurl'],
        // Misc info
        totalgraminpackage: json['totalgraminpackage'],
        totalitemsinpackage: json['totalitemsinpackage'],
        shop: json['shop'],
        barcode: json['barcode']
      );

  Map<String, dynamic> updatetoJson() => {
        'name': name,
        'kcal': kcal,
        'protein': protein,
        'carbohydrates': carbohydrates,
        'fat': fat,
        'carbohydratessugar': carbohydratessugar,
        'fatsaturated': fatsaturated,
        'salt' : salt,
        'pictureurl': pictureurl,
        // Misc info
        'totalgraminpackage': totalgraminpackage,
        'totalitemsinpackage': totalitemsinpackage,
        'shop': shop,
        'barcode' : barcode
      };
}
