import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto/constants.dart';
import 'package:dam_proyecto/services/auth_service.dart';
import 'package:dam_proyecto/services/fs_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecetaAgregar extends StatefulWidget {
  const RecetaAgregar({super.key});

  @override
  State<RecetaAgregar> createState() => _RecetaAgregarState();
}

class _RecetaAgregarState extends State<RecetaAgregar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController instruccionesCtrl = TextEditingController();
  String  CategoriaElegida = "1";
  String AutorCtrl = 'el yo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Receta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: TextFormField(
                    validator: (nombre) {
                      if (nombre!.isEmpty) {
                        return 'Ingrese nombre';
                      }
                      return null;
                    },
                    controller: nombreCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                ),
                
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Categorias').snapshots(), builder: (context,snapshot){
                    List<DropdownMenuItem> categoriaItems = [];
                    final categorias = snapshot.data?.docs.reversed.toList();
                    categoriaItems.add(DropdownMenuItem(value:"0", child: Text('elija categoria')));
                    for(var categoria in categorias!){
                      categoriaItems.add(DropdownMenuItem(value:categoria.id, 
                      child: Text(categoria['categoria'])
                        )
                      );
                    }
                    return DropdownButton(items: categoriaItems, onChanged: (categoriaValue){
                      setState(() {
                        CategoriaElegida = categoriaValue;
                      });
                      print(categoriaValue);
                    },
                    value: CategoriaElegida,
                    isExpanded: false,
                    );
                    
                  }),

               Container(
                  margin: EdgeInsets.all(5),
                  child: TextFormField(
                    validator: (instrucciones) {
                      if (instrucciones!.isEmpty) {
                        return 'Coloque Instrucciones';
                      }
                      return null;
                    },
                    controller: instruccionesCtrl,
                    decoration: InputDecoration(
                      labelText: 'Instrucciones',
                    ),
                  ),
                ),
                //intento de conseguir el autor
                Container(
                  child: FutureBuilder(
                    future: AuthService().currentUser(),
                    builder: (context, AsyncSnapshot<User?> snapshot) {
                      return Text(snapshot.data!.email!);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                          FsService().agregarReceta(
                          nombreCtrl.text,
                          //palceholder para el combo
                          CategoriaElegida,
                          instruccionesCtrl.text,
                          AutorCtrl,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Agregar Receta'),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(kDoradoColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}