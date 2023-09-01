import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class CatandDogRecog extends StatefulWidget {
  const CatandDogRecog({super.key});

  @override
  State<CatandDogRecog> createState() => _CatandDogRecogState();
}

class _CatandDogRecogState extends State<CatandDogRecog> {
  bool is_loading = true;
  File? _image;
  List? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      print(_output);
      is_loading = false;
    });
  }

  loadModel() async {
    try {
      await Tflite.loadModel(
          model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future imagePickerGallery() async {
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      setState(() {
        _image = File(image.path);
      });
      classifyImage(_image!);
    } catch (e) {}
  }

  Future imagePickerCamera() async {
    try {
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;
      setState(() {
        _image = File(image.path);
      });
      classifyImage(_image!);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cat vs Dog Detector"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Cat vs Dog Classification",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Detect Dogs and Cats",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: is_loading
                    ? Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Loading Model..."),
                          ],
                        ),
                      )
                    : Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _image != null
                            ? ClipRRect(child: Image.file(_image!))
                            : Center(child: Text("No image selected")),
                      ),
              ),
              SizedBox(height: 20),
              _output != null
                  ? Text(
                      'Prediction: ${_output![0]['label']}',
                      style: TextStyle(fontSize: 18),
                    )
                  : Container(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      imagePickerCamera();
                    },
                    child: Text("Take a Photo"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      imagePickerGallery();
                    },
                    child: Text("Upload a Photo"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
