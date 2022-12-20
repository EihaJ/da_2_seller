import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../db/slider.dart';

class AddSlider extends StatefulWidget {
  @override
  _AddSliderState createState() => _AddSliderState();
}

class _AddSliderState extends State<AddSlider> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController sliderNameController = TextEditingController();

  SliderServices _sliderServices = SliderServices();

  File _image;

  Color grey = Colors.grey;

  bool isLoading = false;
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Add slider",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Center(child: CircularProgressIndicator())),
                      )
                    : Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: OutlinedButton(
                                  onPressed: () {
                                    _selectImage(
                                        ImagePicker().pickImage(
                                            source: ImageSource.gallery),
                                        1);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey.withOpacity(
                                        0.8,
                                      ),
                                    ),
                                  ),
                                  child: _displayImage()),
                            ),
                          ),
                          SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: sliderNameController,
                              decoration: InputDecoration(
                                  hintText: "Slider Name",
                                  hintStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter slider name!";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Active now:',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 18.0),
                              ),
                              Switch(
                                  value: isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      isActive = value;
                                    });
                                  }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                100.0, 50.0, 100.0, 0.0),
                            child: ElevatedButton(
                              onPressed: () {
                                validationAndUpload();
                              },
                              child: Text(
                                "Add slider",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }

  void _selectImage(Future<XFile> pickImage, int imageNumber) async {
        XFile xtempImg = await pickImage;
    File tempImg = File(xtempImg.path);
    setState(() {
      _image = tempImg;
    });
  }

  Widget _displayImage() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 70.0),
        child: Icon(Icons.add),
      );
    } else {
      return Image.file(
        _image,
        width: 250,
        height: 300,
      );
    }
  }

  void validationAndUpload() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if (_image != null) {
        String imageUrl;

        final FirebaseStorage storage = FirebaseStorage.instance;

        final String picture =
            "${sliderNameController.text}${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task = storage.ref().child(picture).putFile(_image);

        TaskSnapshot snapshot = await task.then((snapshot) => snapshot);

        imageUrl = await snapshot.ref.getDownloadURL();

        _sliderServices.createSlider(
            sliderNameController.text, isActive, imageUrl);
        //_formKey.currentState.reset();

        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(
            msg: "Added slider succesfully!",
            fontSize: 18.0,
            textColor: Colors.white,
            backgroundColor: Colors.black,
            timeInSecForIosWeb: 2);

        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Please choose the slider image!",
            fontSize: 18.0,
            textColor: Colors.white,
            backgroundColor: Colors.black,
            timeInSecForIosWeb: 2);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Please complete fill up the form!",
          fontSize: 18.0,
          textColor: Colors.white,
          backgroundColor: Colors.black,
          timeInSecForIosWeb: 2);
    }
  }
}
