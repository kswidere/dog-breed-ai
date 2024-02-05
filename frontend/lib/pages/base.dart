import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageWithCard extends StatelessWidget {
  const ImageWithCard({super.key, this.imagePath, this.image, required this.child});

  final String? imagePath;
  final Uint8List? image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff112225), Color(0xff0B152A), Color(0xff1B1128)],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imagePath != null 
                  ? AssetImage(imagePath!)
                  : MemoryImage(image!) as ImageProvider<Object>,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Positioned(
          top:  MediaQuery.of(context).size.height / 2 - 30,
          left: 0,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
            width: MediaQuery.of(context).size.width,
            child: child,
          ),
        ),
      ],
    );
  }
}