import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

enum CollectionMenu{ edit, delete }

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
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
              width: 400,
              height: 120,
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
                                  fontWeight: FontWeight.w500,
                              ),
                            overflow: TextOverflow.fade,
                            maxLines: collection.description.isNotEmpty ? 2 : 2,
                          ),
                          Text(collection.description,
                              style: const TextStyle(
                                  fontSize: 12
                              ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text('${collection.bookCount} ${collection.bookCount == 1 ? 'Book' : 'Books'}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  if(library.permissions > 1) PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<CollectionMenu>>[
                      if(library.permissions > 1) PopupMenuItem<CollectionMenu>(
                        value: CollectionMenu.edit,
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.pencil,
                              size: 36,
                              semanticLabel: 'edit collection details',
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text('Edit')
                          ],
                        )
                      ),
                      if(library.permissions > 1 && collection.isUserModifiable) PopupMenuItem<CollectionMenu>(
                        value: CollectionMenu.delete,
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.trash_fill,
                              size: 36,
                              semanticLabel: 'delete collection',
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text('Delete')
                          ],
                        ),
                      )
                    ],
                    onSelected: (CollectionMenu item) {
                      switch(item){
                        case CollectionMenu.edit:
                          onEditCollection?.call();
                          break;
                        case CollectionMenu.delete:
                          onDeleteCollection?.call();
                          break;
                      }
                    },
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}