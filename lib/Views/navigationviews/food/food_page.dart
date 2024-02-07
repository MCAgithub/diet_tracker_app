import 'package:diet_tracker_app/Views/navigationviews/food/add_food_dialog.dart';
import 'package:diet_tracker_app/database_classes/db_firebase_functions.dart';
import 'package:diet_tracker_app/database_classes/db_food.dart';
import 'package:diet_tracker_app/main.dart';
import 'package:flutter/material.dart';

import 'package:diet_tracker_app/Widgets/my_sliverappbar.dart';

import 'package:diet_tracker_app/helperfunctions.dart';

Color searchboxcolor = Colors.blueGrey;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage> {
  var searchcontroller = TextEditingController();
  List<Food> searchedFood = [];

  @override
  void initState() {
    super.initState();
    searchcontroller.addListener(_sortedFood);
  }

  // updates the app everytime something is typed into the searchcontroller
  void _sortedFood() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder(
          stream: DatabaseFirebasefunctions.readFooditems(useremail),
          builder: (context, snapshot) {
            double screenWidth = MediaQuery.of(context).size.width;
            int crossAxisCount = screenWidth > 700 ? 4 : 3;
            if (screenWidth > 800) {
              crossAxisCount = 5;
            }
            if (screenWidth > 1000) {
              crossAxisCount = 6;
            }
            if (screenWidth > 1400) {
              crossAxisCount = 7;
            }
            if (screenWidth > 1600) {
              crossAxisCount = 8;
            }

            if (snapshot.hasError) {
              if (snapshot.error.toString() ==
                  'FirebaseError: [code=resource-exhausted]: Quota exceeded.') {
                return const Center(
                    child: Text('Beklager databasegrænsen er nået'));
              } else {
                return Text('Database Fejl $snapshot');
              }
            } else if (snapshot.hasData) {
              searchedFood = snapshot.data!
                  .where((food) => food.name
                      .toLowerCase()
                      .contains(searchcontroller.text.toLowerCase()))
                  .toList();
              return CustomScrollView(
                slivers: [
                  MySliverAppBar(
                    title: 'Fødevare',
                    appbarHeight: 150,
                    stackedWidget:
                        MySearchTextField(searchcontroller: searchcontroller),
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      //maxCrossAxisExtent: 150,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 145,
                                width: 125,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      leadingcaptial(searchedFood[index].name),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Spacer(),
                                    Material(
                                      elevation: 10,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                          height: 125,
                                          width: 125,
                                          fit: BoxFit.cover,
                                          image: searchedFood[index]
                                                          .pictureurl !=
                                                      null &&
                                                  searchedFood[index]
                                                          .pictureurl !=
                                                      ""
                                              ? NetworkImage(searchedFood[index]
                                                  .pictureurl as String)
                                              : const AssetImage(
                                                      'assets/images/defaultFooditem.png')
                                                  as ImageProvider<Object>,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                                child: Icon(Icons.error));
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          FoodDialogController foodDialogController =
                              FoodDialogController();
                          foodDialogController.foodid = searchedFood[index].id;
                          // name
                          foodDialogController.foodname.text =
                              searchedFood[index].name;
                          // picture
                          searchedFood[index].pictureurl != null
                              ? foodDialogController.foodpictureurl =
                                  searchedFood[index].pictureurl!
                              : null;
                          // page 1
                          foodDialogController.foodkcal.text =
                              searchedFood[index].kcal.toString();
                          foodDialogController.foodprotein.text =
                              searchedFood[index].protein != null
                                  ? searchedFood[index].protein.toString()
                                  : '';
                          foodDialogController.foodcarbohydrates.text =
                              searchedFood[index].carbohydrates != null
                                  ? searchedFood[index].carbohydrates.toString()
                                  : '';
                          foodDialogController.foodfat.text =
                              searchedFood[index].fat != null
                                  ? searchedFood[index].fat.toString()
                                  : '';
                          foodDialogController.foodcarbohydratessugar.text =
                              searchedFood[index].carbohydratessugar != null
                                  ? searchedFood[index]
                                      .carbohydratessugar
                                      .toString()
                                  : '';
                          foodDialogController.foodfatsaturated.text =
                              searchedFood[index].fatsaturated != null
                                  ? searchedFood[index].fatsaturated.toString()
                                  : '';
                          foodDialogController.foodsalt.text =
                              searchedFood[index].salt != null
                                  ? searchedFood[index].salt.toString()
                                  : '';

                          // page 2
                          searchedFood[index].shop != null
                              ? foodDialogController.foodshop.text =
                                  searchedFood[index].shop!
                              : '';
                          searchedFood[index].totalgraminpackage != null
                              ? foodDialogController
                                      .foodtotalgraminpackage.text =
                                  searchedFood[index]
                                      .totalgraminpackage!
                                      .toString()
                              : '';
                          searchedFood[index].totalitemsinpackage != null
                              ? foodDialogController
                                      .foodtotalitemsinpackage.text =
                                  searchedFood[index]
                                      .totalitemsinpackage!
                                      .toString()
                              : '';
                          searchedFood[index].barcode != null
                              ? foodDialogController.foodbarcode.text =
                                  searchedFood[index].barcode!.toString()
                              : '';

                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AddFoodDialog(
                                  foodDialogController: foodDialogController,
                                  state: 'edit'));
                          //addFoodDialog(context, foodDialogController, true);
                        },
                      );
                    }, childCount: searchedFood.length),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class MySearchTextField extends StatelessWidget {
  const MySearchTextField({
    super.key,
    required this.searchcontroller,
  });

  final TextEditingController searchcontroller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          //style: TextStyle(color: Colors.transparent),
          controller: searchcontroller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: searchboxcolor, width: 2),
                borderRadius: BorderRadius.circular(25.0)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: searchboxcolor, width: 2),
                borderRadius: BorderRadius.circular(25.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: searchboxcolor, width: 2),
                borderRadius: BorderRadius.circular(25.0)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: searchboxcolor),
                borderRadius: BorderRadius.circular(25.0)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: searchboxcolor),
                borderRadius: BorderRadius.circular(25.0)),
            labelText: 'Søg',
            labelStyle: const TextStyle(color: Colors.black),
            hintText: '',
            helperText: '',
            helperStyle: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
