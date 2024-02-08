import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning/pages/base.dart';
import 'package:learning/pages/reslut.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Uint8List?> selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return file.readAsBytes();
    }
    return null;
  }

  Future<Map<String, double>> getPredictions(Uint8List imageData) async {
    String base64Image = base64Encode(imageData);
    Uri apiUrl = Uri.parse("http://127.0.0.1:8000/breed-prediction");
    
    var response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'image': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Map<String, double>.from(data);
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ImageWithCard(
      imagePath: 'assets/homeboy.png',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "What breed is he?",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Center(
              child: Text(
                "Let AI guess any dog’s breed from photo",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 40,),
          ElevatedButton(
            onPressed: () async {
              Uint8List? image = await selectImage();
              
              if (image != null) {
                Map<String, double> result = await getPredictions(image);
                print(result);
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ResultPage(image: image,)),
                );
              }
            },
            child: Text(
              "Upload a picture",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 30,),
        ]
      ),
    );
  }
}