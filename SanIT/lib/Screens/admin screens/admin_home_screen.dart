import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sanit/Model/user_models.dart';
import 'package:sanit/Screens/admin%20screens/admin_home_screen.dart';
import 'package:sanit/Screens/admin%20screens/manage_user_screen.dart';
import 'package:sanit/Screens/admin%20screens/user_requests_screen.dart';

import 'package:sanit/Screens/user%20screens/faq_screen.dart';
import 'package:sanit/Screens/login_screen.dart';
import 'package:sanit/Screens/user%20screens/home_screen.dart';

import 'package:sanit/Screens/profile_screen.dart';


class adminHomePage extends StatefulWidget {
  const adminHomePage({Key? key}) : super(key: key);

  @override
  _adminHomePageState createState() => _adminHomePageState();
}

class _adminHomePageState extends State<adminHomePage> {

  //display user details
  User? user = FirebaseAuth.instance.currentUser;
  userModel loggedInUser = userModel();

  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);


  final auth = FirebaseAuth.instance;

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
    super.initState();
    // checkState();
  }

  @override
  Widget build(BuildContext context) {
    //CHECK IF USER IS AN ADMIN OR USER
    if (loggedInUser.accountType == 'user') {
      print(loggedInUser.accountType.toString());
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => homePage()),
                (route) => false);
      });
    }

    return Scaffold(
      // backgroundColor: Colors.redAccent,
        appBar: AppBar(
            title: Text("Admin Home Page"), centerTitle: true,backgroundColor: santanderRed,),

        body: CustomScrollView(

          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 2,
                children: <Widget>[
                  //PROFILE WIDGET
                  Material(
                    child: InkWell(
                      onTap: ()  {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => profilePage()));
                        setState(() {
                        });
                      },
                      child: Container(
                        child:  Image.asset("assets/profile.png",
                          fit: BoxFit.scaleDown,width: 18,height:18,),
                      ),
                    ),
                  ),
                  //VIEW REQUEST
                  Material(
                    child: InkWell(
                      onTap: ()  {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => viewUserRequestsPage()));
                        setState(() {
                        });
                      },
                      child: Container(
                        child:  Image.asset("assets/view-request.png",
                          fit: BoxFit.scaleDown,width: 18,height:18,),
                      ),
                    ),
                  ),
                  //FAQ PAGE
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

                  //MANAGE USERS
                  Material(

                    child: InkWell(
                      onTap: ()  {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => managerUsers()));

                      },
                      child: Container(
                        child:  Image.asset("assets/manage-users.png",
                          fit: BoxFit.scaleDown,width: 18,height:18,),
                      ),
                    ),
                  ),
                  //LOGOUT PAGE
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
    //LOGOUT
    await FirebaseAuth.instance.signOut();
    //BACK TO HOME PAGE
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => loginScreen()));
  }

}

