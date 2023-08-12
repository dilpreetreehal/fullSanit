import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sanit/Screens/user%20screens/home_screen.dart';

import 'package:sanit/Screens/reg_screen.dart';

import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final auth = FirebaseAuth.instance;

  bool bioEnabled = false;

  late SharedPreferences loginData;
  late bool newUser = true;

  final localAuth = LocalAuthentication();
  static const santanderRed = Color(0xffec0000);
  static const santanderDarkRed = Color(0xffcc0000);

  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          //VALIDATE EMAIL
          return ("Please enter your email");
        }
        //SANTANDER EMAIL
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email address");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ));

    //LOGIN BUTTON
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: santanderRed,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                              child: Image.asset("assets/santander-logo.png",
                                  fit: BoxFit.contain),
                            ),
                            SizedBox(height: 25),
                            emailField,
                            SizedBox(height: 25),
                            passwordField,
                            SizedBox(height: 25),
                            loginButton,
                            SizedBox(height: 25),

                            //LINKED TEXT TO REGISTER ACCOUNT
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Don't have an account? "),
                                  //LINK TAPPED
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              //REG SCREEN
                                              builder: (context) => regScreen()));
                                    },
                                    //DESIGN FOR SIGN UP
                                    child: const Text("Sign-up",
                                        style: TextStyle(
                                            color: santanderDarkRed,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15)),
                                  ),
                                ]),
                            // Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: <Widget>[
                            //       Text("Not a user?"),
                            //       GestureDetector(onTap: (){
                            //         // Navigator.push(context,MaterialPageRoute(builder: (context) => adminLoginScreen()));
                            //       },
                            //         child: const Text("Admin login",
                            //             style: TextStyle(
                            //                 color: Colors.red,
                            //                 fontWeight: FontWeight.w800, fontSize: 15)),
                            //       ),
                            //     ]
                            // )
                          ],
                        ))),
              ))),
    );
  }

  Future<void> signIn(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_formKey.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        // loginData.setBool('login', true),

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => homePage()))
      })
          .catchError((e) {
        {
          Fluttertoast.showToast(msg: e!.message);
        }
      });
    }
  }

  Future<void> checkLogin() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);
    print(newUser);

    print("new user");
    if (newUser == false) {
      print(newUser);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homePage()));
    }
  }
}
