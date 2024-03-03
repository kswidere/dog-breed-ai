import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pawspective/pages/base.dart';
import 'package:pawspective/pages/home.dart';
import 'package:pawspective/pages/loading.dart';

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
    http.Response? response;

    try {
      response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'image': base64Image,
        }),
      );
    } on SocketException {
      if (context.mounted) {
        showErrorDialog(context, "Encountered an error with our server. Try again later!");
      }
    }

    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      Map<String, double> filteredData = filterPredictions(Map<String, double>.from(data));
      setState(() {
        _breeds = filteredData;
        _isLoading = false;
      });
    } else if (response != null && context.mounted) {
      showErrorDialog(context, "Picture's format unsupported. Try a different picture!");
    }
  }

  Map<String, double> filterPredictions(Map<String, double> predictions) {
    predictions.removeWhere((k, v) => (v < 0.1));
    final sorted = predictions.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    predictions = {for (var entry in sorted) entry.key: entry.value};
    if (predictions.isEmpty) {
      predictions = {"Unique": 1};
    }
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
      : Animate(
        effects: [SlideEffect(begin: const Offset(1, 0), duration: 150.ms)],
        child: ImageWithCard(
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
        ),
      );
  }
  
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text("Oops...", style: Theme.of(context).textTheme.displayLarge)),
          content: Text(message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Back to home page", style: Theme.of(context).textTheme.labelMedium),
              onPressed: () { Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const HomePage()),
              ); },
            ),
          ],
        );
      }
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