import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  }

  classifyImage(File image) async {
    // final interpreter = await Interpreter.fromAsset("")
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
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

      // final interpreter =
      //     await Interpreter.fromAsset('assets/model_unquant.tflite');
      //     await IsolateInterpreter(address: )
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Cat vs Dog Classification",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Detect Dogs and Cats",
                style: TextStyle(),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                  child: is_loading
                      ? Container(
                          child: Column(children: [
                            Image.asset(
                              "assets/catvsdog.png",
                              width: 300,
                              height: 300,
                            )
                          ]),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                child: Image.file(_image!),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _output != null
                                  ? Text('${_output![0]['label']}')
                                  : Container()
                            ],
                          ),
                        )),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          imagePickerCamera();
                        },
                        child: Text("Take a photo ")),
                    ElevatedButton(
                        onPressed: () {
                          imagePickerGallery();
                        },
                        child: Text("Upload a photo "))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// tflite erros
//  dependencies {
//         implementation 'org.tensorflow:tensorflow-lite:+'
//         implementation 'org.tensorflow:tensorflow-lite-gpu:+'
//     }
