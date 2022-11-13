import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

enum LibraryMenu{ share, edit, delete }

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    Key? key,
    required this.library,
    this.onTap,
    this.onEditShare,
    this.onEditLibrary,
    this.onDeleteLibrary
  }) : super(key: key);

  final Library library;
  final VoidCallback? onTap;
  final VoidCallback? onEditShare;
  final VoidCallback? onEditLibrary;
  final VoidCallback? onDeleteLibrary;

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
                        Text(library.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text('${library.bookCount} ${library.bookCount == 1 ? 'Book' : 'Books'}',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic
                            )
                        ),
                        Text(library.permissionsName)
                      ],
                    ),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<LibraryMenu>>[
                    if(library.permissions == 3) PopupMenuItem<LibraryMenu>(
                      value: LibraryMenu.share,
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.person_2_fill,
                            size: 36,
                            semanticLabel: 'manage sharing',
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                          Text('Permissions')
                        ],
                      )
                    ),
                    if(library.permissions == 3) PopupMenuItem<LibraryMenu>(
                      value: LibraryMenu.edit,
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.pencil,
                            size: 36,
                            semanticLabel: 'edit library details',
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                          Text('Edit')
                        ],
                      )
                    ),
                    PopupMenuItem<LibraryMenu>(
                      value: LibraryMenu.delete,
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.trash_fill,
                            size: 36,
                            semanticLabel: 'delete library',
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                          Text('Delete')
                        ],
                      )
                    )
                  ],
                  onSelected: (LibraryMenu item){
                    switch(item){
                      case LibraryMenu.share:
                        onEditShare?.call();
                        break;
                      case LibraryMenu.edit:
                        onEditLibrary?.call();
                        break;
                      case LibraryMenu.delete:
                        onDeleteLibrary?.call();
                        break;
                    }
                  },
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

}