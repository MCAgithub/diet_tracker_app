import 'package:diet_tracker_app/Widgets/my_textfield.dart';
import 'package:diet_tracker_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Login page colors
var loginPageBackGroundColor = Colors.white;
var loginPageTextColor = Colors.green.shade400;
var loginPageBorderColor = loginPageTextColor;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetPasswordController = TextEditingController();
  final borderCircularVal = 20.0;

  var emailHelperText = '';
  var passwordHelperText = '';
  var resetpasswordHelperText = '';

  var emailHintColor = loginPageTextColor;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            'Diet Tracker',
            style: GoogleFonts.dancingScript(
                color: loginPageTextColor,
                fontSize: 40,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_background.png'),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          BorderRadius.all(Radius.circular(borderCircularVal))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      MyTextField(
                        labelText: 'Bruger Navn',
                        helperText: emailHelperText,
                        controller: emailController,
                        borderColor: loginPageBorderColor,
                        obscure: false,
                        borderCircular: borderCircularVal,
                      ),
                      MyTextField(
                        labelText: 'Adgangskode',
                        helperText: passwordHelperText,
                        controller: passwordController,
                        borderColor: loginPageBorderColor,
                        obscure: true,
                        borderCircular: borderCircularVal,
                      ),
                      TextButton(
                        child: Text(
                          'Glemt adgangskode',
                          style: TextStyle(color: loginPageTextColor),
                        ),
                        onPressed: () {
                          forgotPasswordDialog(context);
                        },
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: loginPageBorderColor, width: 1))),
                        child: Text(
                          'Login',
                          //style: Theme.of(context).textTheme.bodyLarge,
                          style: TextStyle(color: loginPageTextColor),
                        ),
                        onPressed: () {
                          signIn();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                //SizedBox(
                //  height: MediaQuery.of(context).size.height / 10,
                //)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> forgotPasswordDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Nulstil adgangskode',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: loginPageTextColor),
            ),
            content: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MyTextField(
                    labelText: 'Email',
                    helperText: resetpasswordHelperText,
                    controller: resetPasswordController,
                    borderColor: loginPageBorderColor,
                    obscure: false,
                    borderCircular: borderCircularVal,
                  ),
                ],
              );
            }),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Send nulstillings email',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  resetPassword();
                },
              ),
              TextButton(
                child: Text(
                  'Luk',
                  style: TextStyle(color: loginPageTextColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future signIn() async {
    // Displays loading circle on full screen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailHelperText = '';
        passwordHelperText = '';
      });
      // ignore: avoid_print
      print(e.code);
      if (e.code == "invalid-email") {
        setState(() {
          emailHelperText = 'brugeren findes ikke';
        });
      }
      if (e.code == "missing-password") {
        setState(() {
          passwordHelperText = 'skriv venlist din adgangskode';
        });
      }
      if (e.code == "invalid-login-credentials") {
        setState(() {
          passwordHelperText = 'forkert adgangskode';
        });
      }
      if (e.code == "too-many-requests") {
        setState(() {
          emailHelperText =
              'For mange forkerte forsøg prøv igen om 60 sekunder';
        });
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future resetPassword() async {
    setState(() {
      resetpasswordHelperText = '';
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetPasswordController.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: loginPageBackGroundColor,
              content: const Text(
                  'Nulstillings Email Sendt! \nVenlist tjek din email og vær opmærksom på at den vil blive sendt fra \nnoreply@mcadatabase-21ef3.firebaseapp.com'),
            );
          });
    } on FirebaseAuthException catch (e) {
      setState(() {
        resetpasswordHelperText = '';
      });
      // ignore: avoid_print
      print(e.code);
      if (e.code == "missing-email") {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: loginPageBackGroundColor,
                content: const Text('Skriv Venlist din email'),
              );
            });
      }
      if (e.code == "invalid-email") {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: loginPageBackGroundColor,
                content: const Text('Skriv venlist din email'),
              );
            });
      }
    }
  }
}
