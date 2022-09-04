import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class CollectionTile extends StatelessWidget {
  const CollectionTile({Key? key, required this.collection, this.onTap}) : super(key: key);

  final Collection collection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(20),
        onTap: onTap,
        child: SizedBox(
            width: 400,
            height: 100,
            child: Column(
              children: [
                Text(collection.name),
                Text(collection.description)
              ],
            )
        ),
      ),
    );
  }
}