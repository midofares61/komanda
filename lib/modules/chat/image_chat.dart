import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageChat extends StatelessWidget {
  final image;
  ImageChat({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: InteractiveViewer(
              maxScale: 10,
              child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  child: Image.memory(base64Decode(image))))),
    );
  }
}
