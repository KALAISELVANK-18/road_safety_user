

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:road_safety/presistant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_safety/signin.dart';


class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _formkey = GlobalKey<FormState>();

  @override

    Widget build(BuildContext context) {
      TextEditingController email=new TextEditingController();
      TextEditingController pass=new TextEditingController();
      TextEditingController conpass=new TextEditingController();
      TextEditingController fname=new TextEditingController();
      TextEditingController lname=new TextEditingController();
      TextEditingController name=new TextEditingController();
      return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255,255,255),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(children: [
                SizedBox(height: 15,),
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
                    'Have a safe ride!',
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 23),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Name";
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(

                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Name'),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter License number";
                        }
                        return null;
                      },
                      controller: fname,
                      decoration: InputDecoration(

                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'License number'),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextFormField(

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Phone";
                        }
                        return null;
                      },
                      controller: lname,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(10)),
                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter Phone'),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextFormField(

                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        }
                        return null;
                      },
                      controller: email,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(10)),
                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter Email'),
                    )),
                Padding(

                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        }
                        return null;
                      },
                      controller: pass,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(10)),
                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter Password',
                      ),
                      obscureText: true,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter valid input";

                        }

                        if(pass.text!=conpass.text){
                          return "please check the password";
                        }
                        if(pass.text.toString().length<6){
                          return "please enter long password";
                        }

                        return null;

                      },
                      controller: conpass,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(10)),
                          filled: true, //<-- SEE HERE
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter Confirm password'),obscureText: true
                    ),
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
                        'Sign Up',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                      onPressed: () async{

                        try {

                          if(_formkey.currentState!.validate())
                          {
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email.text,
                              password: pass.text,
                            );

                            await FirebaseFirestore.instance.collection(email.text).doc("personinfo").set({

                              "license_number":fname.text.toString(),
                              "phone_number":lname.text.toString(),
                              "name":name.text

                            });
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyHomePage1(),
                              ),
                            );
                          }


                        } on FirebaseAuthException catch (e) {
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
                //     Container(
                //       height: 20,
                //       width: 20,
                //       child: Padding(
                //         padding: EdgeInsets.only(top: 20),
                //         child: Image.asset('images/gg.png'),
                //       ),
                //     ),
                //     Container(
                //       height: 20,
                //       width: 20,
                //       child: Padding(
                //         padding: EdgeInsets.only(top: 20),
                //         child: Image.asset('images/apple.png'),
                //       ),
                //     ),
                //
                //   ],
                // ),
                SizedBox(height: 0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Center(

                      child: Padding(

                        padding: EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text('Already a User?',
                                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
                            TextButton(onPressed:(){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Signin(),
                                ),
                              );
                            },
                              child: Text('Login here',
                                style: GoogleFonts.poppins(fontSize: 17, color: Colors.greenAccent,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),

              ]),
            ),
          ),
        ),
      );
    }
  }

