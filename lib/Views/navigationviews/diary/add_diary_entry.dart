import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_tracker_app/database_classes/db_diary.dart';
import 'package:diet_tracker_app/database_classes/db_firebase_functions.dart';
import 'package:diet_tracker_app/database_classes/db_food.dart';
import 'package:diet_tracker_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDiaryEntry extends StatefulWidget {
  final String mealname;
  final List<MealItem>? snappedMeals;
  const AddDiaryEntry({
    super.key,
    required this.mealname,
    this.snappedMeals,
  });

  @override
  State<AddDiaryEntry> createState() => _AddDiaryEntryState();
}

class _AddDiaryEntryState extends State<AddDiaryEntry> {
  final _searchcontroller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isDropdownOpened = false;
  Food? _dropdownValue;

  int? displayPackageGram;
  TextEditingController gramController = TextEditingController();
  int? displayedKCAL;
  double? displayedCarbs;
  double? dispalyedProtein;
  double? displayedFat;

  List<MealItem> buildingMeal = [];

  List<Food> fooditems = [];

  // Layout
  Color bottomColor = Colors.green.shade200;
  double borderCircular = 20;

  @override
  void initState() {
    fetchFoodItems();
    buildingMeal.addAll(widget.snappedMeals ?? []);
    super.initState();
  }

  void fetchFoodItems() async {
    List<Food> foodList =
        await DatabaseFirebasefunctions.readFooditemsList(useremail);
    setState(() {
      fooditems = foodList;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);
    int timestamp = dateOnly.millisecondsSinceEpoch;

    var filteredItems = _searchcontroller.text.isEmpty
        ? fooditems
        : fooditems
            .where((item) => item.name
                .toLowerCase()
                .contains(_searchcontroller.text.toLowerCase()))
            .toList();

    var mealkcal = buildingMeal.fold(0, (sum, item) => sum + item.calories);

    return GestureDetector(
        onTap: () {
          if (_isDropdownOpened) {
            setState(() {
              _isDropdownOpened = false;
              _focusNode.unfocus();
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              widget.mealname,
              style: GoogleFonts.dancingScript(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: Container(
              //height: appbarHeight*0.82,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.red,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple
                  ],
                ),
              ),
            ),
          ),
          //title: Text(widget.mealname),
          //content: SingleChildScrollView(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 400,
                          width: 300,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/menu_card.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          height: 220,
                          width: 220,
                          bottom: 50,
                          child: Center(
                            //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.red),

                            child: ListView.builder(
                                //itemCount: snapmeals.length,
                                itemCount: buildingMeal.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      //snapmeals[index].itemName,
                                      buildingMeal[index].itemName,
                                      style: GoogleFonts.dancingScript(
                                          //color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    trailing: Text(
                                      //'${snapmeals[index].amountGramEaten}g',
                                      '${buildingMeal[index].amountGramEaten}g',
                                      style: GoogleFonts.dancingScript(
                                          //color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                buildingMeal[index].itemName),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                //const Text('Måltid info:'),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('kcal: '),
                                                    Text(buildingMeal[index]
                                                        .calories
                                                        .toString()),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Kulhydrater: '),
                                                    Text(buildingMeal[index]
                                                        .carbohydrates
                                                        .toString()),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Protein: '),
                                                    Text(buildingMeal[index]
                                                        .protein
                                                        .toString()),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Fedt: '),
                                                    Text(buildingMeal[index]
                                                        .fat
                                                        .toString()),
                                                  ],
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  String idToRemove =
                                                      buildingMeal[index].id;
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .doc(useremail)
                                                        .collection(
                                                            'DiaryEntries')
                                                        .doc(timestamp
                                                            .toString())
                                                        .collection('Meals')
                                                        .doc(idToRemove)
                                                        .delete();
                                                    buildingMeal.removeWhere(
                                                        (mealItem) =>
                                                            mealItem.id ==
                                                            idToRemove);
                                                    setState(() {});
                                                  } catch (e) {
                                                    // ignore: avoid_print
                                                    print(e);
                                                  }
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Close'),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                    Text('Total kcal for måltid : $mealkcal'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.green.shade100),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            
                            IgnorePointer(
                              ignoring: !_isDropdownOpened,
                              child: Visibility(
                                visible: _isDropdownOpened,
                                child: Material(
                                  elevation: 10,
                                  child: SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: filteredItems.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title:
                                              Text(filteredItems[index].name),
                                          onTap: () {
                                            setState(() {
                                              _dropdownValue =
                                                  filteredItems[index];

                                              displayPackageGram =
                                                  filteredItems[index]
                                                      .totalgraminpackage;
                                              gramController.text = '100';
                                              displayedKCAL =
                                                  filteredItems[index].kcal;
                                              displayedCarbs =
                                                  filteredItems[index]
                                                      .carbohydrates;
                                              dispalyedProtein =
                                                  filteredItems[index].protein;
                                              displayedFat =
                                                  filteredItems[index].fat;

                                              _searchcontroller.text =
                                                  _dropdownValue!.name;
                                              _isDropdownOpened = false;
                                              _focusNode.unfocus();
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),const SizedBox(
                        height: 10,
                      ),
                            TextFormField(
                              controller: _searchcontroller,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Fødevare eller opskrift',
                                suffixIcon: IconButton(
                                    onPressed: _searchcontroller.clear,
                                    icon: const Icon(Icons.clear)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bottomColor, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bottomColor, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bottomColor, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                              ),
                              onTap: () {
                                setState(() {
                                  _isDropdownOpened = true;
                                });
                              },
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Total gram i pakke: '),
                                Text(displayPackageGram != null
                                    ? displayPackageGram.toString()
                                    : '0'),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('kcal: '),
                                    Text(displayedKCAL != null
                                        ? displayedKCAL.toString()
                                        : '0'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Kulhydrater: '),
                                    Text(displayedCarbs != null
                                        ? displayedCarbs.toString()
                                        : '0'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Protein: '),
                                    Text(dispalyedProtein != null
                                        ? dispalyedProtein.toString()
                                        : '0'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Fedt: '),
                                    Text(displayedFat != null
                                        ? displayedFat.toString()
                                        : '0'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: gramController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'gram i måltid',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bottomColor, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bottomColor, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bottomColor, width: 2),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    borderRadius:
                                        BorderRadius.circular(borderCircular)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // kcal
                                  if (value.isNotEmpty) {
                                    var newKCAL = (_dropdownValue!.kcal *
                                            (int.parse(value) / 100))
                                        .round();
                                    displayedKCAL = newKCAL;
                                  }
                                  // Carbs
                                  if (value.isNotEmpty) {
                                    var newCarbs =
                                        (_dropdownValue!.carbohydrates! *
                                            (int.parse(value) / 100));
                                    displayedCarbs = double.parse(
                                        newCarbs.toStringAsFixed(2));
                                  }
                                  // Protein
                                  if (value.isNotEmpty) {
                                    var newProtein = (_dropdownValue!.protein! *
                                        (int.parse(value) / 100));
                                    dispalyedProtein = double.parse(
                                        newProtein.toStringAsFixed(2));
                                  }
                                  // Fat
                                  if (value.isNotEmpty) {
                                    var newFat = (_dropdownValue!.fat! *
                                        (int.parse(value) / 100));
                                    displayedFat =
                                        double.parse(newFat.toStringAsFixed(2));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  addToMenu();
                                },
                                child: const Text('Tilføj'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  if (_dropdownValue != null) {
                                    addToMenu();
                                    Navigator.pop(context, buildingMeal);
                                  }
                                },
                                child: const Text('Tilføj og afslut'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.pop(context, buildingMeal);
                            },
                            child: const Text('Afslut'),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void addToMenu() {
    setState(
      () {
        if (_dropdownValue != null) {
          var newMealItem = MealItem(
              itemName: _dropdownValue!.name,
              amountGramEaten: int.parse(gramController.text),
              calories: displayedKCAL!,
              carbohydrates: displayedCarbs,
              protein: dispalyedProtein,
              fat: displayedFat,
              mealTime: widget.mealname);

          //mealkcal =
          //    mealkcal + newMealItem.calories;

          //buildingMeal.add(newMealItem);
          _dropdownValue = null;

          displayPackageGram = null;
          displayedKCAL = null;
          displayedCarbs = null;
          dispalyedProtein = null;
          displayedFat = null;

          _searchcontroller.text = '';
          gramController.text = '';

          buildingMeal.add(newMealItem);
          addtoDiaryMeal(newMealItem);
        }
      },
    );
  }

  Future addtoDiaryMeal(MealItem newMeal) async {
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);
    int timestamp = dateOnly.millisecondsSinceEpoch;

    // checks if the day has been registered in the database if not creates it
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(useremail)
        .collection('DiaryEntries')
        .where('date', isEqualTo: timestamp)
        .get();

    late String docid;

    if (querySnapshot.docs.isEmpty) {
      Diary diary = Diary();
      final docUser = FirebaseFirestore.instance
          .collection('Users')
          .doc(useremail)
          .collection('DiaryEntries')
          .doc(timestamp.toString());

      diary.id = docUser.id;
      docid = docUser.id;

      final json = diary.toJson();
      await docUser.set(json);
    } else {
      docid = querySnapshot.docs.first.id;
    }

    /*
      if (docid.isNotEmpty) {
      // delete all docs in collection method - no longer neeeded
      var snaps = await FirebaseFirestore.instance
          .collection('Users')
          .doc(useremail)
          .collection('DiaryEntries')
          .doc(docid)
          .collection(widget.mealname)
          .get();

      for (DocumentSnapshot doc in snaps.docs) {
        await doc.reference.delete();
      }
      }
      */

    // Adds the meals to registration
    final docMeal = FirebaseFirestore.instance
        .collection('Users')
        .doc(useremail)
        .collection('DiaryEntries')
        .doc(docid)
        .collection('Meals')
        .doc();

    newMeal.id = docMeal.id;
    var mealjson = newMeal.toJson();
    await docMeal.set(mealjson);
  }

  // not used and needs work
  Future updateDiary(Diary diary, diaryentry) async {
    //final docUser = FirebaseFirestore.instance.collection('Fooditems').doc();
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc(useremail)
        .collection('DiaryEntries')
        .doc(diaryentry)
        .collection('Meals')
        .doc();

    diary.id = docUser.id;

    final json = diary.toJson();
    await docUser.set(json);
  }
}
