import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:learning/pages/base.dart';
import 'package:learning/pages/loading.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.image});

  final Uint8List image;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading = true;
  Map<String, double> _breeds = {};

  void getPredictions(Uint8List imageData) async {
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

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Map<String, double> filteredPredictions = filterPredictions(Map<String, double>.from(data));
      setState(() {
        _breeds = filteredPredictions;
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Map<String, double> filterPredictions(Map<String, double> predictions) {
    predictions.removeWhere((k, v) => (v < 0.1));
    return predictions;
  }

  @override
  void initState() {
    super.initState();
    getPredictions(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading 
      ? const LoadingPage()
      : ImageWithCard(
        image: widget.image,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Your dog is...",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            for (var breed in _breeds.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: DogBreed(
                  breedName: breed.key,
                  breedPercentage: (breed.value * 100).toInt(),
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