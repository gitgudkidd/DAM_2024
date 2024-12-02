import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  //obtener las recetas
  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('Recetas').snapshots();
  }

  //categoria
  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('Categorias').snapshots();
  }

  //agregar una receta
  Future<void> agregarReceta(String nombre, int categoria, String instrucciones, String autor) {
    return FirebaseFirestore.instance.collection('Recetas').doc().set({
      'nombre': nombre,
      'categoria': categoria,
      'instrucciones': instrucciones,
      'autor': autor,
    });
  }

  //borrar una receta
  Future<void> borrarRecetas(String id) {
    return FirebaseFirestore.instance.collection('Recetas').doc(id).delete();
  }
}
