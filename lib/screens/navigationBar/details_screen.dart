import 'package:book_swap/constants.dart';
import 'package:book_swap/models/books/books_model.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/add_books_screen.dart';
import 'package:book_swap/screens/navigationBar/favorite_screen.dart';
import 'package:book_swap/widgets/sign_button.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Details extends StatefulWidget {
  final BooksModel model;

  Details(this.model);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController textController = TextEditingController();
  String reviewText = 'No Reviews';
  GlobalKey<FormState> textKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.bookTitle),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image(image: widget.model.bookCover == null ? AssetImage('images/book_icon.png') : NetworkImage(widget.model.bookCover)),
              ),
              ScopedModelDescendant(
                builder: (context, child, MainModel mainModel) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton('Edit', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddBooks(title: 'Edit',
                              id: widget.model.bookId,)));
                    }),
                    buildButton('Delete', () async {
                      
                      bool _isDeleted = await mainModel.deleteBooks(widget.model.bookId);
                      if(_isDeleted == true){
                        Scaffold.of(context)
                            .showSnackBar(buildSnackBar('Book Deleted'));
                      } else {
                        Scaffold.of(context).showSnackBar(
                            buildSnackBar('Something went wrong'));
                      }
                    }),
                    buildButton('Add to favorite', () async {
                      bool _isAdded =
                          await mainModel.addToFavorite(widget.model.bookId);
                      if (_isAdded == true) {
                        Scaffold.of(context)
                            .showSnackBar(buildSnackBar('Added To Favorite'));
                      } else {
                        Scaffold.of(context).showSnackBar(
                            buildSnackBar('Something went wrong'));
                      }
                    }),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Summary',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.model.bookSummary,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
              ListTile(
                title: Text(
                  'Reviews',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              postReview(textController, textKey),
              SignButton(
                  text: 'Post',
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Nothing to post'),
                        duration: Duration(seconds: 4),
                      ));
                    } else {
                      setState(() {
                        reviewText = textController.text;
                      });
                    }
                  }),
              reviewCard()
            ],
          ),
        ),
      ),
    );
  }

  postReview(TextEditingController textController, Key key) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          TextFormField(
            validator: (value) => value.isEmpty ? 'Nothing to post' : null,
            key: key,
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Type Your Review',
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }

  reviewCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
          child: Text(
        reviewText,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )),
    );
  }

  buildButton(String text, Function onPressed) {
    return RaisedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        color: text == 'Delete' ? Colors.red : secondaryColor,
        onPressed: onPressed);
  }

  buildSnackBar(String content) {
    return SnackBar(
      content: Text(content),
      duration: Duration(seconds: 4),
    );
  }
}
