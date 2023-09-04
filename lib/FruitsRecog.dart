import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class FruitsRecog extends StatefulWidget {
  const FruitsRecog({super.key});

  @override
  State<FruitsRecog> createState() => _FruitsRecogState();
}

class _FruitsRecogState extends State<FruitsRecog> {
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
      numResults: 131,
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
        model: 'assets/fruits_model.tflite',
        labels: 'assets/labelsvegetables.txt',
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Vegetables Classifier"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              "Fruits and vegetables Classification",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Detect fruits, vegetables",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 32),
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
                          Text("Loading model..."),
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
            _output != null && _output!.isNotEmpty
                ? Text(
                    'Prediction: ${_output![0]['label']}',
                    style: TextStyle(fontSize: 18),
                  )
                : Container(child: Text("Prediction Erroe")),
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
    );
  }
}
