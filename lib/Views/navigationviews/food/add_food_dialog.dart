// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_tracker_app/database_classes/db_food.dart';
import 'package:diet_tracker_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';

class FoodDialogController {
  final _formKey = GlobalKey<FormState>();
  var foodid = '';
  var fooduploader = TextEditingController();
  var foodname = TextEditingController();
  var foodpictureurl = '';
  // page 1
  var foodkcal = TextEditingController();
  var foodprotein = TextEditingController();
  var foodcarbohydrates = TextEditingController();
  var foodfat = TextEditingController();
  var foodcarbohydratessugar = TextEditingController();
  var foodfatsaturated = TextEditingController();
  var foodsalt = TextEditingController();
  // page 2
  var foodtotalgraminpackage = TextEditingController();
  var foodtotalitemsinpackage = TextEditingController();
  var foodshop = TextEditingController();
  var foodbarcode = TextEditingController();

/*
  var foodnamehelper;
  var foodkcalhelper;
  var foodproteinhelper;
  var foodcarbohydrateshelper;
  var foodfathelper;
  var foodcarbohydratessugarhelper;
  var foodfatsaturatedhelper;
  var foodpicturehelper;
  var foodshophelper;
*/
  void dispose() {
    fooduploader.dispose();
    foodid = '';
    foodname.dispose();
    foodkcal.dispose();
    foodprotein.dispose();
    foodcarbohydrates.dispose();
    foodfat.dispose();
    foodcarbohydratessugar.dispose();
    foodfatsaturated.dispose();
    foodsalt.dispose();
    foodpictureurl = '';
    foodshop.dispose();
  }
}

var reg = r'^-?(\d+)?.?(\d*)?$';

class AddFoodDialog extends StatefulWidget {
  final FoodDialogController foodDialogController;
  final String state;
  const AddFoodDialog(
      {super.key, required this.foodDialogController, required this.state});

  @override
  AddFoodDialogState createState() => AddFoodDialogState();
}

class AddFoodDialogState extends State<AddFoodDialog>
    with TickerProviderStateMixin {
//Future<dynamic> addFoodDialog(
//    BuildContext context, FoodDialogController controller, bool edit) {
  Uint8List? file;
  bool _uploadInProgress = false;
  bool _disableButton = false;
  late TaskSnapshot uploadTask;
  //var edit;
  //FoodDialogController controller = FoodDialogController();
  //File? file;
  //return showDialog(
  //barrierDismissible: false,
  //context: context,
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void handleAddButtonPress() async {
      if (widget.foodDialogController._formKey.currentState!.validate()) {
        if (file != null) {
          String uniqueFilename =
              '${widget.foodDialogController.foodname.text}_${DateTime.now().microsecondsSinceEpoch}';

          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('image');

          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFilename);

          try {
            setState(() {
              _uploadInProgress = true;
              _disableButton = true;
            });

            await referenceImageToUpload.putData(file!);

            setState(() {
              _uploadInProgress = false;
            });

            widget.foodDialogController.foodpictureurl =
                await referenceImageToUpload.getDownloadURL();
          } catch (e) {
            // ignore: avoid_print
            print(e);
          }
        }

        var newfood = Food(
          uploader: FirebaseAuth.instance.currentUser!.email.toString(),
          name: widget.foodDialogController.foodname.text,
          // picture
          pictureurl: widget.foodDialogController.foodpictureurl,
          // page 1
          kcal: int.parse(widget.foodDialogController.foodkcal.text),
          fat: double.tryParse(widget.foodDialogController.foodfat.text),
          fatsaturated: double.tryParse(
              widget.foodDialogController.foodfatsaturated.text),
          carbohydrates: double.tryParse(
              widget.foodDialogController.foodcarbohydrates.text),
          carbohydratessugar: double.tryParse(
              widget.foodDialogController.foodcarbohydratessugar.text),
          protein:
              double.tryParse(widget.foodDialogController.foodprotein.text),
          salt: double.tryParse(widget.foodDialogController.foodsalt.text),
          // page 2
          totalgraminpackage: int.tryParse(
              widget.foodDialogController.foodtotalgraminpackage.text),
          totalitemsinpackage: int.tryParse(
              widget.foodDialogController.foodtotalitemsinpackage.text),
          shop: widget.foodDialogController.foodshop.text,
          barcode: int.tryParse(widget.foodDialogController.foodbarcode.text),
        );
        addNewFoodItem(newfood);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ny fødevare tilføjet'),
          backgroundColor: Colors.white,
        ));
        widget.foodDialogController.dispose();
        Navigator.pop(context);
      }
    }

    void handleEditButtonPress() async {
      if (widget.foodDialogController._formKey.currentState!.validate()) {
        if (file != null) {
          String uniqueFilename =
              '${widget.foodDialogController.foodname.text}_${DateTime.now().microsecondsSinceEpoch}';

          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('image');

          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFilename);

          try {
            setState(() {
              _uploadInProgress = true;
              _disableButton = true;
            });

            uploadTask = await referenceImageToUpload.putData(file!);

            setState(() {
              _uploadInProgress = false;
            });

            widget.foodDialogController.foodpictureurl =
                await referenceImageToUpload.getDownloadURL();
          } catch (e) {
            // ignore: avoid_print
            print(e);
          }
        }

        var newfood = Food(
          uploader: FirebaseAuth.instance.currentUser!.email.toString(),
          name: widget.foodDialogController.foodname.text,
          // picture
          pictureurl: widget.foodDialogController.foodpictureurl,
          // page 1
          kcal: int.parse(widget.foodDialogController.foodkcal.text),
          fat: double.tryParse(widget.foodDialogController.foodfat.text),
          fatsaturated: double.tryParse(
              widget.foodDialogController.foodfatsaturated.text),
          carbohydrates: double.tryParse(
              widget.foodDialogController.foodcarbohydrates.text),
          carbohydratessugar: double.tryParse(
              widget.foodDialogController.foodcarbohydratessugar.text),
          protein:
              double.tryParse(widget.foodDialogController.foodprotein.text),
          salt: double.tryParse(widget.foodDialogController.foodsalt.text),
          // page 2
          totalgraminpackage: int.tryParse(
              widget.foodDialogController.foodtotalgraminpackage.text),
          totalitemsinpackage: int.tryParse(
              widget.foodDialogController.foodtotalitemsinpackage.text),
          shop: widget.foodDialogController.foodshop.text,
          barcode: int.tryParse(widget.foodDialogController.foodbarcode.text),
        );
        updateFoodItem(newfood, widget.foodDialogController.foodid);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Fødevare redigeret'),
          backgroundColor: Colors.white,
        ));
        widget.foodDialogController.dispose();
        Navigator.pop(context);
      }
    }

    void handleDeleteButtonPress() async {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(useremail)
            .collection('Fooditems')
            .doc(widget.foodDialogController.foodid)
            .delete();
        //buildingMeal.removeWhere((mealItem) => mealItem.id == idToRemove);
        setState(() {});
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
      Navigator.pop(context);
    }

    return Stack(children: [
      AlertDialog(
        title: Text(
          widget.state == 'add' ? 'Tilføj Fødevare' : 'Rediger Fødevare',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Form(
                key: widget.foodDialogController._formKey,
                child: SizedBox(
                  // controlls size of box, if not set wraps to smallest possible
                  //height: 400,
                  //width: screenWidth,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              //ImagePicker imagePicker = ImagePicker();
                              //XFile? pickedImage = await imagePicker.pickImage(
                              //    source: ImageSource.gallery);
                              //if (pickedImage != null) {
                              //  file = File(pickedImage!.path);
                              //}

                              file = await ImagePickerWeb.getImageAsBytes();

                              //final ImagePicker picker = ImagePicker();
                              //file = await picker.pickImage(source: ImageSource.camera);
                              //print(file?.path);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: 190,
                              child: TextField(
                                controller:
                                    widget.foodDialogController.foodname,
                                decoration: const InputDecoration(
                                    label: Text('Navn'),
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black))),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TabBar(controller: tabController, tabs: const [
                        Text('Næringsindhold'),
                        Text('Produkt info')
                      ]),
                      SizedBox(
                        height: screenHeight / 3,
                        width: screenWidth < 600 ? screenWidth : 600,
                        child: TabBarView(controller: tabController, children: [
                          // page 1
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const Text('Næringsindhold pr. 100g'),
                                formitem(
                                    widget.foodDialogController.foodkcal,
                                    'Energi (kcal)*',
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5),
                                    ],
                                    50),
                                formitem(
                                    widget.foodDialogController.foodfat,
                                    'fedt (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(reg)),
                                      LengthLimitingTextInputFormatter(4),
                                      DecimalInputFormatter(),
                                    ],
                                    50),
                                formitem(
                                    widget
                                        .foodDialogController.foodfatsaturated,
                                    '- heraf mættede fedtsyrer (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(reg)),
                                      LengthLimitingTextInputFormatter(5),
                                      DecimalInputFormatter(),
                                    ],
                                    50),
                                formitem(
                                    widget
                                        .foodDialogController.foodcarbohydrates,
                                    'Kulhydrat (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(reg)),
                                      LengthLimitingTextInputFormatter(5),
                                      DecimalInputFormatter(),
                                    ],
                                    50),
                                formitem(
                                    widget.foodDialogController
                                        .foodcarbohydratessugar,
                                    '- heraf sukkerarter (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(reg)),
                                      LengthLimitingTextInputFormatter(5),
                                      DecimalInputFormatter(),
                                    ],
                                    50),
                                formitem(
                                    widget.foodDialogController.foodprotein,
                                    'Protein (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(reg)),
                                      LengthLimitingTextInputFormatter(5),
                                      DecimalInputFormatter(),
                                    ],
                                    50),
                                formitem(
                                    widget.foodDialogController.foodsalt,
                                    'Salt (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: true),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(reg)),
                                      LengthLimitingTextInputFormatter(5),
                                      DecimalInputFormatter(),
                                    ],
                                    50),
                              ],
                            ),
                          ),
                          // page 2
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text('Produkt Info'),
                                /*formitem(
                                    widget.foodDialogController.foodkcal,
                                    'Produkt type - Dropdown',
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5)
                                    ],
                                    50),*/
                                formitem(
                                    widget.foodDialogController
                                        .foodtotalgraminpackage,
                                    'gram i pakke (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5)
                                    ],
                                    50),
                                formitem(
                                    widget.foodDialogController
                                        .foodtotalitemsinpackage,
                                    'antal i pakke (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(5)
                                    ],
                                    50),
                                const SizedBox(
                                  height: 20,
                                ),
                                formitem(widget.foodDialogController.foodshop,
                                    'Købs Butik (valgfri)', null, null, 150),
                                formitem(
                                    widget.foodDialogController.foodbarcode,
                                    'Stregkode (valgfri)',
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                    <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(13)
                                    ],
                                    150),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          // IF EDITING
          if (widget.state == 'edit') ...[
            TextButton(
                onPressed: _disableButton ? null : handleDeleteButtonPress,
                child: const Text(
                  'Slet',
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: _disableButton ? null : handleEditButtonPress,
                child: const Text('Rediger')),
          ],
          // IF ADDING NEW
          if (widget.state == 'add')
            TextButton(
                onPressed: _disableButton ? null : handleAddButtonPress,
                child: const Text('Tilføj')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Luk')),
        ],
      ),
      _uploadInProgress == true
          ? const Stack(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              ],
            )
          : Container()
    ]);
  }

  Future addNewFoodItem(Food food) async {
    //final docUser = FirebaseFirestore.instance.collection('Fooditems').doc();
    final docUser = FirebaseFirestore.instance
        .collection('Users')
        .doc(useremail)
        .collection('Fooditems')
        .doc();

    food.id = docUser.id;

    final json = food.toJson();
    await docUser.set(json);
  }
}

Future updateFoodItem(Food food, String editID) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(useremail)
      .collection('Fooditems')
      .doc(editID);

  final json = food.updatetoJson();
  await docUser.update(json);
}

Row formitem(
    TextEditingController controller,
    String label,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    double width) {
  return Row(
    //mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(label),
      const Spacer(),
      SizedBox(
        width: width,
        child: TextField(
          textAlign: TextAlign.end,
          controller: controller,
          keyboardType: textInputType,
          inputFormatters: [CommaToPeriodInputFormatter()],
          decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black))),
        ),
      ),
    ],
  );
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // This allows both comma and period as decimal separators
    final RegExp regExp = RegExp(reg);
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class CommaToPeriodInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains(',')) {
      String newText = newValue.text.replaceAll(',', '.');
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}
