import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/isbn_lookup/bloc/isbn_lookup_bloc.dart';
import 'package:library_app/isbn_lookup/models/isbn.dart';
import 'package:library_app/widgets/widgets.dart';

class IsbnLookupPage extends StatelessWidget {
  const IsbnLookupPage({Key? key}) : super(key: key);

  static Route<BookLookupDetails?> route(){
    return MaterialPageRoute<BookLookupDetails?>(
      builder: (context) => BlocProvider(
        create: (context) => IsbnLookupBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const IsbnLookupPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ISBN Lookup'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<IsbnLookupBloc, IsbnLookupState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == FormzStatus.submissionFailure){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Unable to find ISBN'))
                    );
              }else if(state.status == FormzStatus.submissionSuccess){
                Navigator.of(context).pop(state.details);
              }
            },
          )
        ],
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _IsbnInput(),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                      ElevatedButton(
                        onPressed: () async {
                          BarcodeScanner.scan(
                            options: const ScanOptions(
                              restrictFormat: [BarcodeFormat.ean13]
                            )
                          ).then((barcodeResult) {
                            if(barcodeResult.type == ResultType.Barcode) {
                              context.read<IsbnLookupBloc>().add(IsbnChanged(barcodeResult.rawContent));
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          minimumSize: const Size.fromHeight(50)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Scan Barcode'),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                            Icon(
                              CupertinoIcons.camera,
                              size: 36,
                              semanticLabel: 'camera',
                            )
                          ],
                        ),
                      )
                    ],
                  )
                )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    CancelButton(
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    BlocBuilder<IsbnLookupBloc, IsbnLookupState>(
                      buildWhen: (previous, current) => previous.status != current.status,
                      builder: (context, state) {
                        return SubmitButton(
                          text: 'Search',
                          onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<IsbnLookupBloc>().add(const Submitted()) : null
                        );
                      },
                    )
                  ],
                )
              )
            )
          ],
        ),
      ),
    );
  }
}

class _IsbnInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsbnLookupBloc, IsbnLookupState>(
        buildWhen: (previous, current) => previous.isbn != current.isbn,
        builder: (context, state) {
          final controller = TextEditingController(text: state.isbn.value);
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            onChanged: (isbn) => EasyDebounce.debounce('isbn_lookup_isbn', const Duration(milliseconds: 500), () => context.read<IsbnLookupBloc>().add(IsbnChanged(isbn))),
            decoration: InputDecoration(
                labelText: 'ISBN',
                hintText: 'ISBN-10 / ISBN-13 no spaces or hyphens',
                errorText: _getError(state.isbn.error)
            ),
            maxLength: 13,
          );
        }
    );
  }

  String? _getError(IsbnValidationError? error){
    if(error != null) {
      switch (error) {
        case IsbnValidationError.empty:
          return 'ISBN required';
        case IsbnValidationError.format:
          return 'invalid format';
      }
    }
    return null;
  }
}