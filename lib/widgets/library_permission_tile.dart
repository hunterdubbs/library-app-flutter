import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class LibraryPermissionTile extends StatelessWidget {
  const LibraryPermissionTile({
    Key? key,
    required this.library,
    required this.permission,
    this.onDeletePermission,
    this.onDeleteInvite
  }) : super(key: key);

  final Library library;
  final LibraryPermission permission;
  final VoidCallback? onDeletePermission;
  final VoidCallback? onDeleteInvite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(20),
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
                        Text(permission.username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        Text(permission.permissionName,
                          style: const TextStyle(
                            fontSize: 14
                          )
                        )
                      ],
                    ),
                  )
                ),
                if(library.permissions == 3) SizedBox(
                  width: 50,
                  height: 90,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      size: 36,
                      semanticLabel: 'remove permission',
                    ),
                    onPressed: permission.isInvite ? onDeleteInvite : onDeletePermission,
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }

}