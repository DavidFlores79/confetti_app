import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confetti Example')),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _controller.play(); // Start the confetti animation
                // Action when button is pressed
              },
              child: Text('Press Me'),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -pi / 2, // Direction to blast the confetti
              emissionFrequency: 0.2, // Frequency of confetti emission
              numberOfParticles: 30, // Number of confetti particles
              blastDirectionality:
                  BlastDirectionality.explosive, // How the confetti is emitted
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null, // Add your action here
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
