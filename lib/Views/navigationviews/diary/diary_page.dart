import 'package:flutter/material.dart';
import 'package:diet_tracker_app/main.dart';
import 'package:diet_tracker_app/database_classes/db_firebase_functions.dart';
import 'package:diet_tracker_app/Views/navigationviews/diary/add_diary_entry.dart';
import 'package:diet_tracker_app/Widgets/my_sliverappbar.dart';
import 'package:diet_tracker_app/database_classes/db_diary.dart';
import 'package:diet_tracker_app/Widgets/my_circularpainter.dart';
import 'package:diet_tracker_app/Widgets/my_nutrients_widget.dart';

// ignore: must_be_immutable
class DiaryPage extends StatefulWidget {
  const DiaryPage({
    super.key,
  });

  //final ValueNotifier<List<MealElement>> meals;

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  ValueNotifier<int> totalkcal = ValueNotifier<int>(0);
  ValueNotifier<int> kcal = ValueNotifier<int>(0);
  int breakfastkcal = 0;
  int lunchkcal = 0;
  int dinnerkcal = 0;
  int snackkacl = 0;

  var maxcal = 2000;

  Map<String, List<MealItem>> daysMeals = {};

  List<String> meals = [
    'Morgenmad',
    'Frokost',
    'Aftensmad',
    'Snacks',
  ];

  List<int> mealskcal = [0, 0, 0, 0];

  int selectedCardIndex = -1;

  @override
  void initState() {
    fecthDiaryFB();
    super.initState();
  }

  void updateKcal() {
    // updates the mealskcal list from the daysMeals list
    for (var i = 0; i < 4; i++) {
      if (daysMeals[meals[i]] != null) {
        var thiskcal =
            daysMeals[meals[i]]?.fold(0, (sum, item) => sum + item.calories);
        mealskcal[i] = thiskcal!;
      }
    }

    // calculates the total kcal from the mealskcal list
    int total = mealskcal.fold(0, (sum, mealkcal) => sum + mealkcal);
    //WidgetsBinding.instance.addPostFrameCallback(
    //  (_) {
        if (mounted) {
          setState(
            () {
              kcal.value = total;
            },
          );
        }
    //  },
    //);
  }

  void fecthDiaryFB() async {
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);
    int timestamp = dateOnly.millisecondsSinceEpoch;

    List<MealItem> snapmeals = await DatabaseFirebasefunctions.readDaysMeals(
        useremail, timestamp.toString());

    //List<MealItem> snapmeals = [];

    for (MealItem meal in snapmeals) {
      if (!daysMeals.containsKey(meal.mealTime)) {
        daysMeals[meal.mealTime] = [];
      }
      daysMeals[meal.mealTime]!.add(meal);
    }

    updateKcal();

    //DatabaseFirebasefunctions.readDaysMeals(useremail, timestamp.toString())
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);
    // ignore: unused_local_variable
    int timestamp = dateOnly.millisecondsSinceEpoch;

    List<Widget> cards =
        List.generate(4, (index) => _buildCard(index, daysMeals[meals[index]]));

    return CustomScrollView(
      slivers: [
        MySliverAppBar(
          title: 'Dagbog',
          appbarHeight: 350,
          centerWidget: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.4),
            painter: CircularPaint(progressValue: kcal.value / maxcal),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: totalkcal,
                builder: ((context, value, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        style: const TextStyle(color: Colors.white),
                        '${kcal.value.toString()} kcal',
                      ),
                      const Text(
                        'Indtaget',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
          stackedWidget: Column(
            children: [
              const NutrientsWidget(),
              //const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.green.shade200,
                        size: 25,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.green.shade200,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000).day}/${DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000).month}/${DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000).year}',
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.green.shade200,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: SizedBox(
              //height: 350,
              child: Stack(
                children: cards,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(int index, List<MealItem>? cardMeals) {
    cardMeals ??= [];
    bool isSelected = index == selectedCardIndex;
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.8;
    double topOffset = isSelected ? 0.0 : (55.0 * index);

    bool visibility = (selectedCardIndex == -1 || selectedCardIndex == index);

    var mealkcal = cardMeals.fold(0, (sum, item) => sum + item.calories);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: topOffset,
      left: (screenWidth - cardWidth) / 2,
      right: (screenWidth - cardWidth) / 2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCardIndex =
                isSelected ? -1 : index; // Deselect if already selected
          });
        },
        child: Visibility(
          visible: visibility,
          child: Card(
            color: Colors.transparent,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(25.0), // Adjust the radius here
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 220),
              width: MediaQuery.of(context).size.width - 120,
              //color: Colors.white,//Colors.primaries[index % Colors.primaries.length],
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Stack(
                children: [
                  Positioned(
                    top: 3,
                    right: 3,
                    child: IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () async {
                        final newItems = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AddDiaryEntry(
                                mealname: meals[index],
                                snappedMeals: cardMeals,
                              );
                            },
                          ),
                        );

                        daysMeals[meals[index]] = [];
                        for (MealItem meal in newItems) {
                          //if (!daysMeals.containsKey(meal.mealTime)) {
                          //  daysMeals[meal.mealTime] = [];
                          //} else {
                          daysMeals[meal.mealTime]!.add(meal);
                        }

                        updateKcal();
                        //setState(() {});
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        meals[index],
                        //style: const TextStyle(height: 1),
                        textAlign: TextAlign.center,
                      ),
                      Divider(
                        indent: 150,
                        endIndent: 150,
                        height: 2,
                        color: Colors.grey.shade500,
                      ),
                      Text(
                        'Kcal : $mealkcal',
                        //style: const TextStyle(height: 1),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: cardMeals
                            .map((item) => SizedBox(
                                  width: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.itemName),
                                      Text('${item.calories.toString()} kcal'),
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
