import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SliderServices {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "sliders";
  //Create Brand
  void createSlider(String name, bool isActive ,String image) {
    var id = new Uuid();
    String sliderId = id.v1();
    _fireStore.collection(ref).doc(sliderId).set({
      "sliderID" : sliderId,
      'sliderName': name,
      "sliderImage" : image,
      "isActive" : isActive
    });
  }

  void updateSlider(String selectId, String name, bool isActive, String image){
    try{
      _fireStore.collection(ref).doc(selectId).update({
        "sliderID" : selectId,
        'sliderName': name,
        "sliderImage" : image,
        "isActive" : isActive
      });
    }catch(e){
      print(e.toString());
    }
  }

  void deleteSlider(String selectId){
    try{
      _fireStore.collection(ref).doc(selectId).delete();
    }catch(e){
      print(e.toString());
    }
  }
}