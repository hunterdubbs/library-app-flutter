import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class CollectionTile extends StatelessWidget {
  const CollectionTile({
    Key? key,
    required this.collection,
    required this.library,
    this.onTap,
    this.onEditCollection,
    this.onDeleteCollection
  }) : super(key: key);

  final Library library;
  final Collection collection;
  final VoidCallback? onTap;
  final VoidCallback? onEditCollection;
  final VoidCallback? onDeleteCollection;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
              width: 400,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(collection.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                          Text(collection.description,
                              style: const TextStyle(
                                  fontSize: 12
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(library.permissions > 2) SizedBox(
                    width: 50,
                    height: 90,
                    child: IconButton(
                      icon: const Icon(
                        CupertinoIcons.pencil,
                        size: 36,
                        semanticLabel: 'edit collection details',
                      ),
                      onPressed: onEditCollection,
                    ),
                  ),
                  if(library.permissions > 2) SizedBox(
                    width: 50,
                    height: 90,
                    child: IconButton(
                      icon: const Icon(
                        CupertinoIcons.trash_fill,
                        size: 36,
                        semanticLabel: 'delete collection',
                      ),
                      onPressed: onDeleteCollection,
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}