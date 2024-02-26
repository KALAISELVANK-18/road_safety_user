import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
class MyTabBar extends StatelessWidget {
  const MyTabBar({
    Key? key, required this.tabController,
  }) : super(key: key);

  final TabController tabController;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      height: 80,
      color: Colors.white,
      child: TabBar(

unselectedLabelColor: Colors.black,

        indicatorColor: Colors.red,
        controller: tabController,
        indicator: ShapeDecoration(

            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        tabs: [
          Tab(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Emergency',
                style: GoogleFonts.aclonica(fontSize: 12,color: Colors.red,
                  fontWeight: FontWeight.w600,),

              ),
            ),
          ),
          Tab(
            icon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Speed limit',
                style: GoogleFonts.aclonica(fontSize: 12,color: Colors.yellowAccent,
                  fontWeight: FontWeight.w600,),
              ),
            ),
          ),
          Tab(
            icon: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                'Active drivers',
                style: GoogleFonts.aclonica(fontSize: 11,color: Colors.green,
                  fontWeight: FontWeight.w600,),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
