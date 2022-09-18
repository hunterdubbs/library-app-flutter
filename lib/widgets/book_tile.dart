import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

class BookTile extends StatelessWidget {
  const BookTile({
    Key? key,
    required this.book,
    required this.library,
    this.onTap,
    this.onEditCollection,
    this.onDeleteCollection
  }) : super(key: key);

  final Library library;
  final Book book;
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
                          Text(book.title,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                          Text('${book.authors.first.displayName} ${book.authors.length > 1 ? '( +${book.authors.length - 1} more)' : ''}',
                              style: const TextStyle(
                                  fontSize: 12
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}