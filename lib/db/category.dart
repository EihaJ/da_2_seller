import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryServices{
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "Categories";

  void createCategory(String name, String image){
    var id = new Uuid();
    String categoryId = id.v1();
    _fireStore.collection(ref).doc(categoryId).set({
      "categoryID" : categoryId,
      "categoryName" : name,
      "categoryImage" : image
    });
  }
  Future<List<DocumentSnapshot>> getCategories() =>
      _fireStore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
  void updateCategory(String selectId, String name, String image ){
    try{
      _fireStore.collection(ref).doc(selectId).update({
        "categoryID" : selectId,
        "categoryName" : name,
        "categoryImage" : image,
      });
    }catch(e){
      print(e.toString());
    }
  }

  void deleteCategory(String selectId){
    try{
      _fireStore.collection(ref).doc(selectId).delete();
    }catch(e){
      print(e.toString());
    }
  }
}