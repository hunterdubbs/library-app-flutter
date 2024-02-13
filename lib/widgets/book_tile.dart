import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/data/models/models.dart';

enum BookMenu{ edit, delete, collections}

class BookTile extends StatelessWidget {
  const BookTile({
    Key? key,
    required this.book,
    required this.library,
    this.onTap,
    this.onEditCollections,
    this.onEditBook,
    this.onDeleteBook
  }) : super(key: key);

  final Library library;
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onEditCollections;
  final VoidCallback? onEditBook;
  final VoidCallback? onDeleteBook;

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
                          Text(book.title,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: book.authors.isNotEmpty || book.tags.isNotEmpty ? 1 : 2,
                          ),
                          if(book.authors.isNotEmpty) Text('${book.authors.first.displayName} ${book.authors.length > 1 ? '( +${book.authors.length - 1} more)' : ''}',
                              style: const TextStyle(
                                  fontSize: 12
                              )
                          ),
                          if(book.series.isNotEmpty || book.volume.isNotEmpty) Text('${book.series}${book.volume.isNotEmpty ? ' - Vol. ' : ''}${book.volume}',
                            style: const TextStyle(
                                fontSize: 12
                            )
                          ),
                          if(book.tags.isNotEmpty) Text('Tags: ${book.tags.map((t) => t.name).join(', ')}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  if(library.permissions > 1 && !book.isGroup) PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<BookMenu>>[
                      if(library.permissions > 1) PopupMenuItem<BookMenu>(
                        value: BookMenu.collections,
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.eye_fill,
                              size: 36,
                              semanticLabel: 'visibly collections',
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text('Visible Collections')
                          ],
                        ),
                      ),
                      if(library.permissions > 1 && !book.isGroup) PopupMenuItem<BookMenu>(
                        value: BookMenu.edit,
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.pencil,
                              size: 36,
                              semanticLabel: 'edit book',
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text('Edit')
                          ],
                        ),
                      ),
                      if(library.permissions > 1 && !book.isGroup) PopupMenuItem<BookMenu>(
                        value: BookMenu.delete,
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.trash_fill,
                              size: 36,
                              semanticLabel: 'delete book',
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                            Text('Delete')
                          ],
                        ),
                      ),
                    ],
                    onSelected: (BookMenu item) {
                      switch(item){
                        case BookMenu.collections:
                          onEditCollections?.call();
                          break;
                        case BookMenu.edit:
                          onEditBook?.call();
                          break;
                        case BookMenu.delete:
                          onDeleteBook?.call();
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