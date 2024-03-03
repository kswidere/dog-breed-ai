import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawspective/pages/base.dart';
import 'package:pawspective/pages/reslut.dart';

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
              if (image != null && context.mounted) {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ResultPage(
                    image: image,
                  )),
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