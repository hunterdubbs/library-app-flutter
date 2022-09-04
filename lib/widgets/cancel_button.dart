import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget{
  const CancelButton({this.onTap, Key? key}) : super(key: key);

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
        child: const Text('Cancel')
      )
    );
  }
}