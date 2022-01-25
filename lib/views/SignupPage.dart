import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/widgets/my_text_field.dart';

class SignupPage extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool loading = false;
  UserCredential? userCredential;
  RegExp regExp = RegExp(SignupPage.pattern.toString());
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Future sendData() async {
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(userCredential?.user?.uid)
          .set({
        "firstName": firstName.text.trim(),
        "lastName": lastName.text.trim(),
        "email": email.text.trim(),
        "userid": userCredential?.user?.uid,
        "password": password.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        globalKey.currentState?.showSnackBar(
          SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        globalKey.currentState?.showSnackBar(
          SnackBar(
            content: Text("The account already exists for that email"),
          ),
        );
      }
    } catch (e) {
      globalKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void validation() {
    if (firstName.text.trim().isEmpty || firstName.text.trim() == null) {
      globalKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "firstName is Empty",
          ),
        ),
      );
      return;
    }
    if (lastName.text.trim().isEmpty || lastName.text.trim() == null) {
      globalKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "lastName is Empty",
          ),
        ),
      );
      return;
    }
    if (email.text.trim().isEmpty || email.text.trim() == null) {
      globalKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Email is Empty",
          ),
        ),
      );
      return;
    } else if (!regExp.hasMatch(email.text)) {
      globalKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Please enter vaild Email",
          ),
        ),
      );
      return;
    }
    if (password.text.trim().isEmpty || password.text.trim() == null) {
      globalKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            "Password is Empty",
          ),
        ),
      );
      return;
    } else {
      setState(() {
        loading = true;
      });
      sendData();
    }
  }

  Widget button(
      {required String buttonName,
      required Color color,
      required Color textColor,
      required Function()? ontap}) {
    return Container(
      width: 120,
      child: RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 20, color: textColor),
        ),
        onPressed: ontap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextField(
                      controller: firstName,
                      obscureText: false,
                      hintText: 'fistName',
                    ),
                    MyTextField(
                      controller: lastName,
                      obscureText: false,
                      hintText: 'lastName',
                    ),
                    MyTextField(
                      controller: email,
                      obscureText: false,
                      hintText: 'Email',
                    ),
                    MyTextField(
                      controller: password,
                      obscureText: true,
                      hintText: 'password',
                    )
                  ],
                ),
              ),
              loading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(
                          ontap: () {
                            validation();
                          },
                          buttonName: "Register",
                          color: Colors.greenAccent,
                          textColor: Colors.black,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
