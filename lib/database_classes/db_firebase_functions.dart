import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_tracker_app/database_classes/db_diary.dart';
import 'package:diet_tracker_app/database_classes/db_food.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseFirebasefunctions {
  // Food related functions
  static Stream<List<Food>> readFooditems(useremail) =>
      FirebaseFirestore.instance
          .collection('Users')
          .doc(useremail)
          .collection('Fooditems')
          .orderBy('name', descending: false)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());

  static Future<List<Food>> readFooditemsList(useremail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(useremail)
        .collection('Fooditems')
        .orderBy('name', descending: false)
        .get();

    return querySnapshot.docs
        .map((doc) => Food.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<String> getDownloadUrl(String imageName) async {
    String imageUrl = await FirebaseStorage.instance
        .ref('images/$imageName')
        .getDownloadURL();
    return imageUrl;
  }

  // Diary related functions
  static Stream<List<MealItem>> readMeals(
          String userEmail, String docDay, String mealName) =>
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .collection('DiaryEntries')
          .doc(docDay.toString())
          .collection(mealName)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MealItem.fromJson(doc.data()))
              .toList());

  static Future<List<MealItem>> readDaysMeals(
      String userEmail, String docDay) async {
    QuerySnapshot diaryPage = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmail)
        .collection('DiaryEntries')
        .doc(docDay.toString())
        .collection('Meals')
        .get();

    return diaryPage.docs
        .map((doc) => MealItem.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
