import 'package:book_swap/responsive/responsive.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/add_books_screen.dart';
import 'package:book_swap/screens/navigationBar/details_screen.dart';
import 'package:book_swap/widgets/library_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Library extends StatefulWidget {
  final MainModel model;
  Library(this.model);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  void initState() {
    super.initState();
    widget.model.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBooks(title: 'Add Books'),
                  )))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ScopedModelDescendant(
            builder: (context, child, MainModel model) =>
                buildLibraryItem(model , data)),
      ),
    );
  }

  buildLibraryItem(MainModel model , MediaQueryData data) {
    if (model.isGetBooksLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (model.allBooks.isEmpty) {
      return Center(
        child: Text('No books'),
      );
    } else {
      return GridView.builder(
          itemCount: model.allBooks.length,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: responsive(data)),
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(model.allBooks[i]))),
              child: LibraryCard(
                bookCover: model.allBooks[i].bookCover,
                bookTitle: model.allBooks[i].bookTitle,
                bookRate: model.allBooks[i].bookRate,
              ),
            );
          });
    }
  }
}
