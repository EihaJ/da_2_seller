import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandServices {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "brands";
  //Create Brand
  void createBrand(String name, String address, String phoneNumber, String image) {
    var id = new Uuid();
    String brandId = id.v1();
    _fireStore.collection(ref).doc(brandId).set({
      "brandID" : brandId,
      'brandName': name,
      "brandAddress" : address,
      "brandPhoneNumber" : phoneNumber,
      "brandImage" : image
    });
  }
  Future<List<DocumentSnapshot>> getBrands() =>
        _fireStore.collection(ref).get().then((snaps){
          return snaps.docs;
        });
  void updateBrand(String selectId, String name, String address, String phoneNumber, String image){
    try{
      _fireStore.collection(ref).doc(selectId).update({
        "brandID": selectId,
        "brandName" : name,
        "brandAddress" : address,
        "brandPhoneNumber" : phoneNumber,
        "brandImage" : image
      });
    }catch(e){
      print(e.toString());
    }
  }

  void deleteBrand(String selectId){
    try{
      _fireStore.collection(ref).doc(selectId).delete();
    }catch(e){
      print(e.toString());
    }
  }
}