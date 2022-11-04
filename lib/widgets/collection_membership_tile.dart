import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class CollectionMembershipTile extends StatelessWidget{
  const CollectionMembershipTile({
    Key? key,
    required this.membership,
    this.onTap
  }) : super(key: key);

  final CollectionMembership membership;
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
            width: 400,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Checkbox(
                    value: membership.isMember,
                    onChanged: membership.isUserModifiable ? (value) => onTap : null,
                  ),
                ),
                Text(membership.name,
                  style: const TextStyle(
                    fontSize: 16
                  ),)
              ],
            ),
          ),
        )
      )
    );
  }

}