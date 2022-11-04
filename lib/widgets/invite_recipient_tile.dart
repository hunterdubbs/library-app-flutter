import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class InviteRecipientTile extends StatelessWidget {
  const InviteRecipientTile({
    Key? key,
    required this.invite,
    this.onAccept,
    this.onReject
  }) : super(key: key);

  final Invite invite;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

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
                        Text(invite.libraryName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        Text('From: ${invite.inviterUsername}',
                          style: const TextStyle(
                            fontSize: 14
                          )
                        )
                      ],
                    )
                  )
                ),
                SizedBox(
                  width: 50,
                  height: 90,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.checkmark,
                      size: 36,
                      semanticLabel: 'accept invite',
                    ),
                    onPressed: onAccept,
                  )
                ),
                SizedBox(
                  width: 50,
                  height: 90,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      size: 36,
                      semanticLabel: 'reject invite',
                    ),
                    onPressed: onReject,
                  )
                )
              ],
            )
          )
        ),
      )
    );
  }
}