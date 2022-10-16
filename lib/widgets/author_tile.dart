import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class AuthorTile extends StatelessWidget{
  const AuthorTile({
    Key? key,
    required this.author,
    this.onTap
  }) : super(key: key);

  final Author author;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: 800,
              height: 60,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(author.displayName, style: const TextStyle(fontSize: 14)),
                ),
              )
            )
          ),
        )
    );
  }
}