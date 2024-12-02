import 'package:dam_proyecto/pages/home_page.dart';
import 'package:flutter/material.dart'; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets\images\Fondo_Login.jpg'),
          ),
        ),
        child: Form(
          child: Container(
            child: ListView(
              children: [
                Container(
                  child:TextFormField() ,
                ),
                Container(
                  child: ElevatedButton(onPressed: () async {
                    await signInWithGoogle();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                    child: Text('Iniciar Sesion'),
                  ),
                ), 
              ],
            ),
          )
        ),
      ) 
    );
  }
}

        

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
