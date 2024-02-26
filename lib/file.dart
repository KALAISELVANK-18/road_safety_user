import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:road_safety/signin.dart';


class File extends StatefulWidget {
  const File({super.key});

  @override
  State<File> createState() => _FileState();
}

class _FileState extends State<File> {
  late String? user;
  @override
  void initState() {
    user= FirebaseAuth.instance.currentUser?.email!.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(


        child: StreamBuilder<DocumentSnapshot>(
            stream:  FirebaseFirestore.instance.collection(user!).doc("personinfo").snapshots(),
            builder: (context, AsyncSnapshot snapshot) {



              if (snapshot.hasError) {

                return Text("${snapshot.error}");
              }
              else
              {

                if(snapshot.hasData)
                {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Profile",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      actions: [ElevatedButton(

                          onPressed: ()async{ FirebaseAuth.instance.signOut();
                      PersistentNavBarNavigator.pushNewScreen(
                        context,

                        screen: Signin(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );

                      }, child: Icon(Icons.logout,color: Colors.black,))],
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    snapshot.data!.get("name").toString()
                                    ,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),


                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  user.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 150,
                                  child: Divider(
                                    color: Colors.black,
                                  ),
                                ),

                                Card(
                                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                  child: ListTile(
                                    leading: Icon(Icons.phone, color: Colors.black),
                                    title: Text(
                                      "+91 ${snapshot.data?.get("phone_number")}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.fact_check,
                                      color: Colors.black,
                                    ),
                                    title: Text(
                                      snapshot.data?.get("license_number"),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );



                }

              }
              return Center(
                child: CircularProgressIndicator(),
              );

            }
        ),
      ),
    );
  }
}
