import 'package:dam_proyecto/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dam_proyecto/constants.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [PopupMenuItem(child: Text('Cerrar Sesión'), value: 'logout')],
            onSelected: (opcion) {
              //lamada salida
              signOut(context);

            },

          ),
        ],
      ),
    );
  }
}



Future<void> signOut(BuildContext context) async {
  await _googleSignIn.signOut(); 
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()),(Route<dynamic> route) => false);    
        
}

