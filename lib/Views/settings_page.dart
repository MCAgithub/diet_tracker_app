import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Indstillinger',
            style: TextStyle(color: Colors.white),
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
        body: SizedBox(
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                signOut();
                Navigator.pop(context);
              },
              child: const Text('Log ud'),
            ),
          ),
        ));
  }
}

void signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
