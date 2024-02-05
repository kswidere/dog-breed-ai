import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:learning/pages/base.dart';

class ResultPage extends StatelessWidget {
  ResultPage({super.key, required this.image});

  final Uint8List image;
  final List _breeds = [{"breed": "pomeranian", "percent": 50}, {"breed": "miniature pinscher", "percent": 50}];

  @override
  Widget build(BuildContext context) {
    return ImageWithCard(
      image: image,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Your dog is...",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          for (var breed in _breeds)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: DogBreed(
                breedName: breed["breed"],
                breedPercentage: breed["percent"],
              ),
            ),
          const SizedBox(height: 15,),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back to home page",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 30,),
        ],
        
      )
    );
  }
}

class DogBreed extends StatelessWidget {
  const DogBreed({super.key, required this.breedName, required this.breedPercentage});

  final String breedName;
  final int breedPercentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 30),
            const Icon(Icons.pets, color: Colors.amber),
            const SizedBox(width: 20),
            Text(
              breedName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Text(
            "$breedPercentage%",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ]
    );
  }
}