import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme,
      body: const SafeArea(
        child: Center(
          child: SpinKitSpinningLines(
            color: Colors.white,
            size: 150.0,
          ),
        ),
      ),
    );
  }
}
