import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

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
                        Text(library.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(library.permissionsName)
                      ],
                    ),
                  ),
                ),
                if(library.permissions == 3) SizedBox(
                  width: 50,
                  height: 90,
                    child: IconButton(
                      icon: const Icon(
                        CupertinoIcons.person_2_fill,
                        size: 36,
                        semanticLabel: 'manage sharing',
                      ),
                      onPressed: onEditShare,
                    ),
                ),
                if(library.permissions == 3) SizedBox(
                  width: 50,
                  height: 90,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.pencil,
                      size: 36,
                      semanticLabel: 'edit library details',
                    ),
                    onPressed: onEditLibrary,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 90,
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.trash_fill,
                      size: 36,
                      semanticLabel: library.permissions < 3 ? 'stop following library' : 'delete library',
                    ),
                    onPressed: onDeleteLibrary,
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