import 'dart:io';
import 'package:book_swap/constants.dart';
import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/widgets/sign_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class AddBooks extends StatefulWidget {
  final String title;
  final String id;
  AddBooks({@required this.title, this.id});
  @override
  _AddBooksState createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {
  TextEditingController bookTitleController = TextEditingController();
  TextEditingController bookSummaryController = TextEditingController();
  TextEditingController bookRateController = TextEditingController();
  final titleKey = GlobalKey<FormState>();
  final summaryKey = GlobalKey<FormState>();
  final rateKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  File image;
  String imageUrl;
  ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: ScopedModelDescendant(
              builder: (context, child, MainModel model) => Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    image: DecorationImage(
                                        image: image == null
                                            ? AssetImage('images/book_icon.png')
                                            : FileImage(image),
                                        fit: BoxFit.contain),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: () {
                                        getImage();
                                      }))
                            ],
                          ),
                        ),
                        addInfoField(
                            hintText: 'Book Title',
                            textController: bookTitleController,
                            key: titleKey,
                            keyboardType: TextInputType.name),
                        addInfoField(
                            hintText: 'Book Summary',
                            textController: bookSummaryController,
                            key: summaryKey,
                            keyboardType: TextInputType.name),
                        addInfoField(
                            hintText: 'Book Rate',
                            textController: bookRateController,
                            key: rateKey,
                            keyboardType: TextInputType.number),
                        widget.title == 'Add Books'
                            ? SignButton(
                                text: 'Add Book',
                                onPressed: () async {
                                  if (!_formKey.currentState.validate()) {
                                    Scaffold.of(context).showSnackBar(
                                        buildSnackBar('Some fields required'));
                                  } else {
                                    model.selectBook(widget.id);
                                    model.uploadImageToFireStorage(
                                        image, imageUrl);
                                    bool _addBooks = await model.addBooks(
                                        imageUrl != null ? imageUrl : null,
                                        bookTitleController.text,
                                        bookSummaryController.text,
                                        double.parse(bookRateController.text));
                                    if (_addBooks == true) {
                                      Scaffold.of(context).showSnackBar(
                                          buildSnackBar('Book Added'));
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                          buildSnackBar(
                                              'Something went wrong'));
                                    }
                                  }
                                })
                            : SignButton(
                                text: 'Edit',
                                onPressed: () async {
                                  model.selectBook(widget.id);
                                  if (image != null) {
                                    model.uploadImageToFireStorage(
                                        image, imageUrl);
                                  } else {
                                    print('something is wrong');
                                  }

                                  bool _editBook = await model.updateBooks(
                                      id: widget.id,
                                      image: image == null
                                          ? model.selectedBook.bookCover
                                          : imageUrl,
                                      title: bookTitleController.text.isEmpty
                                          ? model.selectedBook.bookTitle
                                          : bookTitleController.text,
                                      summary:
                                          bookSummaryController.text.isEmpty
                                              ? model.selectedBook.bookSummary
                                              : bookSummaryController.text,
                                      rate: bookRateController.text.isEmpty
                                          ? model.selectedBook.bookRate
                                          : double.parse(
                                              bookRateController.text));

                                  if (_editBook == true) {
                                    Scaffold.of(context).showSnackBar(
                                        buildSnackBar('Book Updated'));
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                        buildSnackBar('Something went wrong'));
                                  }
                                })
                      ],
                    ),
                  )),
        ));
  }

  buildSnackBar(String content) {
    return SnackBar(
      content: Text(content),
      duration: Duration(seconds: 4),
    );
  }

  getImage() async {
    try {
      PickedFile _pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        image = File(_pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  addInfoField(
      {String hintText,
      TextEditingController textController,
      TextInputType keyboardType,
      Key key}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Some fields required' : null,
        controller: textController,
        key: key,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            fillColor: scaffoldBackgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            hintText: hintText),
      ),
    );
  }
}
