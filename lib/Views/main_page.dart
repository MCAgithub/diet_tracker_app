import 'package:flutter/material.dart';

import 'package:diet_tracker_app/Views/navigationviews/diary/diary_page.dart';
import 'package:diet_tracker_app/Views/navigationviews/food/food_page.dart';
import 'package:diet_tracker_app/Views/navigationviews/food/add_food_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final _pageViewController = PageController();
  int _selectedIndex = 0;
  List<Widget> pages = [];

  FoodDialogController foodDialogController = FoodDialogController();

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      const DiaryPage(),
      Container(),
      Container(),
      const FoodPage(),
    ];
  }

/*
  void _handleFabPressforIndex0() {
    var updatedMeals = List<MealElement>.from(meals.value);
    updatedMeals.add(const MealElement());
    meals.value = updatedMeals;
  }
*/
  void _handleFabPressforIndex3() {
    foodDialogController = FoodDialogController();
    //showAboutDialog(context: context, children: [AddFoodDialog()]);
    showDialog(
        context: context,
        builder: (BuildContext context) => AddFoodDialog(
            foodDialogController: foodDialogController, state: 'add'));
    //addFoodDialog(context, foodDialogController, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //appBar:
      //appBar: MyAppBar(title: 'Dagens kalorier', actions: []),
      body: //pages.elementAt(_selectedIndex),
          PageView(
        controller: _pageViewController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
      //),
      //],
      //),
      floatingActionButton: [2, 3].contains(_selectedIndex)
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 5,
              child: const Icon(Icons.add),
              onPressed: () {
                if (_selectedIndex == 3) {
                  _handleFabPressforIndex3();
                }
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: SizedBox(
        height: 80,
        //alignment: Alignment.topCenter,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Icon(Icons.book),
                    Text('Dagbog'),
                  ],
                )),
            BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Icon(Icons.stacked_line_chart),
                    Text('Fremgang'),
                  ],
                )),
            BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Icon(Icons.menu_book),
                    Text('Måltid'),
                  ],
                )),
            BottomNavigationBarItem(
                label: '',
                icon: Column(
                  children: [
                    Icon(Icons.food_bank),
                    Text('Fødevare'),
                  ],
                )),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(
              () {
                //_selectedIndex = val;
                _pageViewController.animateToPage(index,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.ease);
              },
            );
          },
        ),
      ),
    );
  }
}
