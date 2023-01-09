import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:library_app/book_details/bloc/book_details_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({Key? key}) : super(key: key);

  static Route<void> route({required Book book, required Library library}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => BookDetailsBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          book: book,
          library: library
        ),
        child: const BookDetailsPage()
      )
    );
  }

  final TextStyle metaDataTextStyle = const TextStyle(
    color: Colors.black
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(state.book.authors.join(', ')),
                    Text('${state.book.series} - Vol. ${state.book.volume}',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic
                        )),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text(state.book.synopsis,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text('Date Published:  ${DateFormat('MMM dd, yyyy').format(state.book.publishedDate)}', style: metaDataTextStyle),
                    Text('Date Added to Library:  ${DateFormat('MMM dd, yyyy').format(state.book.addedDate)}', style: metaDataTextStyle),
                    Text('Tags: ${state.book.tags.map((t) => t.name).join(', ')}', style: metaDataTextStyle)
                  ],
                ),
              ),
            );
          }),
    );
  }
}