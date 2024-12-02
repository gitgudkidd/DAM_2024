import 'package:dam_proyecto/pages/login_page.dart';
import 'package:dam_proyecto/pages/receta_agregar.dart';
import 'package:dam_proyecto/services/fs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dam_proyecto/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(kDoradoColor),
        foregroundColor: Color(kDoradoColor),
        child: Icon(MdiIcons.plus),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecetaAgregar()));
        },
      ),
      body: 
           Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FsService().recetas(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) { 
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var receta = snapshot.data!.docs[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                FsService().borrarRecetas(receta.id);
                              },
                              icon: Icons.delete,
                              foregroundColor: Color(kDoradoColor),
                              backgroundColor: Color(kOscuroColor),
                              label: 'Borrar Receta',
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(MdiIcons.packageVariant, color: Color(kMedioClaroColor)),
                          title: Text(receta['nombre']),
                          subtitle: Text(receta['autor']),
                          trailing: Text(receta['instrucciones']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );      
}
}  
      
    





Future<void> signOut(BuildContext context) async {
  await _googleSignIn.signOut(); 
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()),(Route<dynamic> route) => false);    
        
}

