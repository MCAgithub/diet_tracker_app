class Diary {
  String id;
  //int date;

  //List<MealItem>? breakfast;
  //List<MealItem>? lunch;
  //List<MealItem>? dinner;
  //List<MealItem>? snack;

  Diary({
    this.id = '',
    //required this.date,
    //this.breakfast,
    //this.lunch,
    //this.dinner,
    //this.snack,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        //'date': date,
        //'breakfast': breakfast,
        //'lunch': lunch,
        //'dinner': dinner,
        //'snack': snack,
      };

  static Diary fromJson(Map<String, dynamic> json) => Diary(
        id: json['id'],
        //date: json['date'],
        //breakfast: json['breakfast'],
        //lunch: json['lunch'],
        //dinner: json['dinner'],
        //snack: json['snack'],
      );

  Map<String, dynamic> updatetoJson() => {
        //'date': date,
        //'breakfast': breakfast,
        //'lunch': lunch,
        //'dinner': dinner,
        //'snack': snack,
      };
}

class MealItem {
  String id;
  String itemName;
  int calories;
  int amountGramEaten;

  double? protein;
  double? carbohydrates;
  double? fat;

  String mealTime;

  MealItem(
      {this.id = '',
      required this.itemName,
      required this.amountGramEaten,
      required this.calories,
      this.protein,
      this.carbohydrates,
      this.fat,
      required this.mealTime});

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemName': itemName,
        'calories': calories,
        'amountGramEaten': amountGramEaten,
        'protein': protein,
        'carbohydrates': carbohydrates,
        'fat': fat,
        'mealTime': mealTime,
      };

  static MealItem fromJson(Map<String, dynamic> json) => MealItem(
      id: json['id'],
      itemName: json['itemName'],
      calories: json['calories'],
      amountGramEaten: json['amountGramEaten'],
      protein: json['protein'],
      carbohydrates: json['carbohydrates'],
      fat: json['fat'],
      mealTime: json['mealTime']);

  Map<String, dynamic> updatetoJson() => {
        'itemName': itemName,
        'calories': calories,
        'amountGramEaten': amountGramEaten,
        'protein': protein,
        'carbohydrates': carbohydrates,
        'fat': fat,
        'mealTime': mealTime,
      };
}
