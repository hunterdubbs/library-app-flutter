import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget{
  const SubmitButton({this.text = 'Submit', this.onTap, Key? key}) : super(key: key);

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            minimumSize: const Size.fromHeight(50)
        ),
        child: Text(text)
      )
    );
  }
}