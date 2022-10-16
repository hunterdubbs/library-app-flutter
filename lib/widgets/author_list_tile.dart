import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class AuthorListTile extends StatelessWidget{
  const AuthorListTile({
    Key? key,
    required this.author,
    this.onDelete
  }) : super(key: key);

  final Author author;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            width: 800,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(author.displayName, style: const TextStyle(fontSize: 14)),
                  )
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.clear,
                      size: 18,
                      semanticLabel: 'remove author',
                    ),
                    onPressed: onDelete,
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
  
}