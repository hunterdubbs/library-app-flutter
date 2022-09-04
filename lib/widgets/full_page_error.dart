import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullPageError extends StatelessWidget {
  const FullPageError({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_triangle_fill,
            color: Colors.red,
            size: 70,
          ),
          Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic
            ),
          )
        ],
      ),
    );
  }
}