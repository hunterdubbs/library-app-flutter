import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class TagTile extends StatelessWidget{
  const TagTile({
    Key? key,
    required this.tag,
    this.onTap
  }) : super(key: key);

  final Tag tag;
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
                      child: Text(tag.name, style: const TextStyle(fontSize: 14)),
                    ),
                  )
              )
          ),
        )
    );
  }
}