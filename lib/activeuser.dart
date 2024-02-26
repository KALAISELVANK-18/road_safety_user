import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_tab_bar.dart';

class Active extends StatefulWidget {
  const Active({super.key});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> with TickerProviderStateMixin{

  late TabController tabController;
  int currentTabIndex = 0;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,

      body:StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection("kalaikgm2003@gmail.com").doc("activeusers").collection("activeusers").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError)
          {
            return Text("${snapshot.error}");
          }
          else
          {
            if(snapshot.hasData) {
              List<DocumentSnapshot>nn=snapshot.data.docs;

              print(nn.length);
              return ListView.builder(

                itemCount: nn.length,
                itemBuilder: (BuildContext context,ind){
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5.0,
                              blurRadius: 5.0,
                              offset: Offset(0, 3), // changes the shadow position
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(left:15.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.phone_android_outlined,size: 25,color: Colors.blueAccent,),SizedBox(width: 5,),
                                                Container(width: 150,child: Text("${nn[ind]["phone_number"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 13,fontWeight: FontWeight.bold)))
                                              ],
                                            ),

                                            SizedBox(height: 5,),

                                            Row(
                                              children: [
                                                Icon(Icons.directions_car_filled_outlined,size: 25,color: Colors.green,),SizedBox(width: 5,),
                                                Text("${nn[ind]["vehicle_number"]}",style:GoogleFonts.poppins(color: Colors.black, fontSize: 16,)),
                                              ],
                                            )


                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10.0,left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(255, 231,	245,	254),
                                                    borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: TextButton(onPressed: (){

                                                },child: Row(
                                                  children: [
                                                    Text("call",style: TextStyle(color: Colors.black)),
                                                    SizedBox(width: 10,),
                                                    Icon(Icons.call,color: Colors.redAccent,),
                                                  ],
                                                ),)),


                                            SizedBox(height: 5,),

                                          ],
                                        ),
                                      ),

                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),



    );


  }
}
