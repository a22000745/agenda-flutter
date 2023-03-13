import 'package:flutter/material.dart';

class SnackBarPage extends StatelessWidget {
  String avisos;
  SnackBarPage({super.key, required this.avisos});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(avisos),
      );
  }
}