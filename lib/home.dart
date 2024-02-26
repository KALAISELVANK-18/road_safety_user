import 'package:admin_road/activeuser.dart';
import 'package:admin_road/emergency.dart';
import 'package:admin_road/speed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_tab_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{

  static Color kPrimaryColor = Color(0xff7C7B9B);
  static Color kPrimaryColorVariant = Color(0xff686795);
  late TabController tabController;
  int currentTabIndex = 0;


  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;

    });
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      onTabChange();
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.addListener(() {
      onTabChange();
    });

    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Center(
          child: Text(
            'Alerts',style: GoogleFonts.aBeeZee(fontSize: 18,
            fontWeight: FontWeight.w600,),

          ),
        ),

        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          MyTabBar(tabController: tabController),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5.0,
                      blurRadius: 5.0,
                      offset: Offset(0, 3), // changes the shadow position
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: TabBarView(
                controller: tabController,
                children: [

                 Emergency(),
                 Speed(),
                  Active()

                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.add),
      ),
    );


  }
}
