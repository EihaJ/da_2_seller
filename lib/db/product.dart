import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductServices {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "products";

  //Create Brand
  void uploadProduct(
      {String productName, String brand, String category, List sizes, List images, double price,double oldPrice, bool sale, bool featured, List colors, String description}) {
    var id = new Uuid();
    String productId = id.v1();
    _fireStore.collection(ref).doc(productId).set({
      "id": productId,
      "name": productName,
      "description" : description,
      "category": category,
      "brand": brand,
      "price": price,
      "oldPrice" : oldPrice,
      "sizes": sizes,
      "images": images,
      "onSale": sale,
      "featured": featured,
      "colors": colors,
    });
  }

  Future<List<DocumentSnapshot>> getProducts() =>
      _fireStore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });

  void updateProduct(String selectId, String name, String brand, String category, List sizes, List images, double price, bool sale, bool featured, List colors, String description, double oldPrice){
    try{
      _fireStore.collection(ref).doc(selectId).update({
        "name": name,
        "category": category,
        "brand": brand,
        "price": price,
        "sizes": sizes,
        "images": images,
        "onSale": sale,
        "featured": featured,
        "colors": colors,
        "description" : description,
        "oldPrice" : oldPrice
      });
    }catch(e){
      print(e.toString());
    }
  }

  void deleteProduct(String selectId){
    try{
      _fireStore.collection(ref).doc(selectId).delete();
    }catch(e){
      print(e.toString());
    }
  }
}