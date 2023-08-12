import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/admin%20screens/admin_home_screen.dart';

import 'package:sanit/Screens/user%20screens/faq_screen.dart';
import 'package:sanit/Screens/login_screen.dart';
import 'package:sanit/Screens/user%20screens/makeRequest_screen.dart';
import 'package:sanit/Screens/profile_screen.dart';
import 'package:sanit/Screens/reg_screen.dart';

import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:sanit/Screens/user%20screens/requests_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  //display user details

  User? user = FirebaseAuth.instance.currentUser;
  userModel loggedInUser = userModel();

  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);

  final auth = FirebaseAuth.instance;

  Future checkColorBlind() async {
    //WAITS SO THAT HAS TIME TO REQUEST DETAILS
    Future.delayed(Duration(milliseconds: 500), () async {
    print("${loggedInUser.colorBlind}");
    SharedPreferences prefs = await SharedPreferences.getInstance();

      if (loggedInUser.colorBlind==true){
        await prefs.setBool('colourBlind', true);
        print("you are colourblind");
      }else if(loggedInUser.colorBlind==false){
        await prefs.setBool('colourBlind', false);
        print("false");

      }
    });
    }



  @override
  void initState() {

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value)
    {
      this.loggedInUser= userModel.fromMap(value.data());
      setState((){
      });
    });
    checkColorBlind();


    super.initState();

    // checkState();
  }

  @override
  Widget build(BuildContext context) {

    if (loggedInUser.accountType == 'admin') {
      print(loggedInUser.accountType.toString());
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => adminHomePage()),
                (route) => false);
      });
    }

      return Scaffold(
          // debugShowCheckedModeBanner: false,
        // backgroundColor: Colors.redAccent,
          appBar: AppBar(
              title: Text("Home Page",), centerTitle: true,backgroundColor: santanderRed),
          body: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              //PROFILE WIDGET
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Material(
                      // color: Colors.red[100],
                      child: InkWell(
                        onTap: ()  {
                           Navigator.push(context, MaterialPageRoute(
                              builder: (context) => profilePage()));
                          setState(() {
                          });
                        },
                        child: Container(
                          child:  Image.asset("assets/profile.png",
                            fit: BoxFit.scaleDown,width: 20,height:20,),
                          ),
                        ),
                      ),
                    //REQUEST WIDGET
                    Material(

                      child: InkWell(
                        onTap: ()  {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => makeRequestPage()));
                        },
                        child: Container(
                          child:  Image.asset("assets/request-logo.png",
                            fit: BoxFit.scaleDown,width: 20,height: 20,),
                        ),
                      ),
                    ),
                    //FAQ WIDGET
                    Material(
                      child: InkWell(
                        onTap: ()  {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => faqPage()));
                        },
                        child: Container(
                          child:  Image.asset("assets/faq.png",
                            fit: BoxFit.scaleDown,width: 18,height:18,),
                        ),
                      ),
                    ),
                    //VIEW REQUEST WIDGET

                    Material(

                      child: InkWell(
                        onTap: ()  {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => requestPage()));
                          setState(() {
                          });
                        },
                        child: Container(
                          child:  Image.asset("assets/view-request.png",
                            fit: BoxFit.scaleDown,width: 18,height:18,),
                        ),
                      ),
                    ),


//LOGOUT WIDGET
                    Material(
                      child: InkWell(
                        onTap: ()  {
                          logout(context);

                        },
                        child: Container(
                          child:  Image.asset("assets/logout.png",
                            fit: BoxFit.scaleDown,width: 18,height:18,),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          )

      );
    }


    Future <void> logout(BuildContext context) async {
      //SIGNS OUT
      await FirebaseAuth.instance.signOut();

      //SENDS YOU BACK TO LOGOUT
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => loginScreen()));
    }

}

