import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:admin_road/presistant.dart';
import 'package:google_fonts/google_fonts.dart';




class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  @override
  Widget build(BuildContext context) {
    TextEditingController email=new TextEditingController();
    TextEditingController pass=new TextEditingController();

    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('image/phone.png')),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Road',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Safety',
                        style: GoogleFonts.poppins(
                            color: Colors.greenAccent,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '+',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Welcome back Admin!',
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 23),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      filled: true, //<-- SEE HERE
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Email'),
                )),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                      filled: true, //<-- SEE HERE
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Password'),
                )),
            Padding(
              padding: EdgeInsets.only(left: 220, top: 10),
              child: Text('Recovery Password',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.white)),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        top: 15, bottom: 15, right: 130, left: 130)),
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  onPressed: () async{

                    try {

                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text,
                        password: pass.text,
                      );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyHomePage1(),
                          ),
                        );

                    }catch(e){
                      print(e);
                    }
                  },
                )),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Or continue with',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(top: 20),
            //       //child: Image.asset('assets/gg.png'),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(top: 20),
            //       //child: Image.asset('assets/apple.png'),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(top: 20),
            //       //child: Image.asset('assets/fb.png'),
            //     ),
            //   ],
            // ),

            SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //
            //     Center(
            //
            //       child: Padding(
            //
            //         padding: EdgeInsets.only(top: 2),
            //         child: Row(
            //           children: [
            //             Text('Not a User?',
            //                 style: GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
            //             TextButton(onPressed:(){
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(
            //                   builder: (context) => const Signup(),
            //                 ),
            //               );
            //             },
            //               child: Text('Signup here',
            //                 style: GoogleFonts.poppins(fontSize: 17, color: Colors.greenAccent,fontWeight: FontWeight.bold),),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //
            //   ],
            // ),
          ]),
        ),
      ),
    );
  }
}
