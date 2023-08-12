import 'dart:async';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class adminFaqPage extends StatefulWidget {
  const adminFaqPage({Key? key}) : super(key: key);

  @override
  _adminFaqPageState createState() => _adminFaqPageState();
}

class _adminFaqPageState extends State<adminFaqPage> {
  Completer<GoogleMapController> _controller = Completer();
  var myMarkers = HashSet<Marker>();
  static const LatLng _center = const LatLng(52.03691341766492, -0.7709746028464721);
  List<Marker> allMarkers=[];
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  static const santanderRed=Color(0xffec0000);
  static const santanderDarkRed=Color(0xffcc0000);

  @override
  void initState() {
    // TODO: implement initState
    allMarkers.add(const Marker(
        markerId: MarkerId("MY Marker"),
        position: LatLng(52.03674803880143, -0.7701159744228577)
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(

            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.white),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                title: Text("FAQs",), centerTitle: true,backgroundColor: santanderRed),

            body:SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ExpansionTile(
                          title: Text('Who manages access requests ?'),
                          // subtitle: Text('Trailing expansion arrow icon'),
                          children: <Widget>[

                            SizedBox(
                              //size depending on screen to keep map readable
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/3,
                              //INCLUDE MAPS API ZOOMED IN
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 14.0,
                                ),
                                //ADD MARKER
                                markers: Set.from(allMarkers),

                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Column(
                                    children: const <Widget>[
                                      //TEAM DETAILS
                                      Text("The SanIT Access Admin team are responsible for managing requests."),
                                      Text("MailBox",style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text("Admin@Santander.co.uk\n"),
                                      Text("Office Location",style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text("201 Grafton Gate,\nMilton Keynes,\nMK9 1AN"),
                                    ]
                                )
                            )
                          ],
                        ),
                        //REQUEST QUESTION
                        ExpansionTile(
                          title: Text('How to manage requests?'),
                          // subtitle: Text('Trailing expansion arrow icon'),
                          children: <Widget>[
                            SizedBox(
                              //size depending on screen to keep map readable
                                width: MediaQuery.of(context).size.width-30,
                                height:100,
                                child: Text("1.GO TO HOME PAGE \n2.CLICK ON NEW REQUESTS.\n3.FILL OUT FORM AND SUBMIT")

                            ),],

                          // ListTile(title: Text('This is tile number 1')),
                        ),
                        //EDIT DETAILS QUESTION
                        ExpansionTile(
                          title: Text('How to manage user details?'),
                          // subtitle: Text('Trailing expansion arrow icon'),
                          children: <Widget>[
                            SizedBox(
                              //size depending on screen to keep map readable
                                width: MediaQuery.of(context).size.width-30,
                                height:100,
                                child: Text("1.GO TO HOME PAGE \n2.CLICK ON PROFILE ICON.\n3.FILL OUT FORM AND SAVE")
                            ),],

                          // ListTile(title: Text('This is tile number 1')),
                        )],

                    )
                )
            )
        )
    );

  }
}
