import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:book_swap/models/books/books_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin BooksController on Model {
  bool _isGetBooksLoading;
  bool get isGetBooksLoading => _isGetBooksLoading;
  bool _isAddBooksLoading;
  bool get isAddBooksLoading => _isAddBooksLoading;
  bool _isUpdateBooksLoading;
  bool get isUpdateBooksLoading => _isUpdateBooksLoading;
  bool _isDeleteBooksLoading;
  bool get isDeleteBooksLoading => _isDeleteBooksLoading;
  bool _isGetFavoriteBooksLoading;
  bool get isGetFavoriteBooksLoading => _isGetFavoriteBooksLoading;
  List<BooksModel> _allBooks = [];
  List<BooksModel> get allBooks => _allBooks;
  List<BooksModel> _favoriteBooks = [];
  List<BooksModel> get favoriteBooks => _favoriteBooks;
    String _selectedBookId;
  BooksModel get selectedBook => _allBooks.firstWhere(
      (BooksModel booksModel) => booksModel.bookId == _selectedBookId);


  selectBook(String id) {
    return _selectedBookId = id;
  }

  String _url =
      'https://book-swap-3492e-default-rtdb.firebaseio.com/books.json';

  Future<bool> getBooks() async {
    print('method started');
    _isGetBooksLoading = true;
    notifyListeners();
    try {
      http.Response _response = await http.get(_url);
      var data = json.decode(_response.body);
      if (_response.statusCode == 200) {
        data.forEach((id, e) {
          final BooksModel _booksModel = BooksModel.fromjson(e, id);
          _allBooks.add(_booksModel);
        });
        _isGetBooksLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
      _isGetBooksLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addBooks(
      String image, String title, String summary, double rate) async {
    _isAddBooksLoading = true;
    notifyListeners();

    Map<String, dynamic> postB = {
      'bookCover': image,
      'bookTitle': title,
      'bookSummary': summary,
      'bookRate': rate,
    };

    try {
      http.Response _response = await http.post(_url, body: json.encode(postB));
      if (_response.statusCode == 200) {
        _isAddBooksLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isAddBooksLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBooks({String id, 
  String image, 
  String title,
      String summary, double rate}) async {
    _isUpdateBooksLoading = true;
    notifyListeners();

    Map<String, dynamic> update = {
      'bookCover': image,
      'bookTitle': title,
      'bookSummary': summary,
      'bookRate': rate,
    };
    try {
      http.Response _response = await http.put(
          'https://book-swap-3492e-default-rtdb.firebaseio.com/books/$id.json',
          body: json.encode(update));
      if (_response.statusCode == 200) {
        _isUpdateBooksLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isUpdateBooksLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBooks(String id) async {
    _isDeleteBooksLoading = true;
    notifyListeners();
    try {
      http.Response _response = await http.delete(
          'https://book-swap-3492e-default-rtdb.firebaseio.com/books/$id.json');
      if (_response.statusCode == 200) {
        _allBooks.removeWhere((BooksModel model) => model.bookId == id);
        _isDeleteBooksLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isDeleteBooksLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addToFavorite(String id) async {
    _isGetFavoriteBooksLoading = true;
    notifyListeners();

    try {
      BooksModel _books = _allBooks
          .firstWhere((BooksModel booksModel) => booksModel.bookId == id);
      _favoriteBooks.add(_books);
      _isGetFavoriteBooksLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isGetFavoriteBooksLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future uploadImageToFireStorage(File image, String imageUrl) async {
    String fileName = path.basename(image.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    final uploadTask = firebaseStorageRef.putFile(image);
    final taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        notifyListeners();
      },
    );
  }

  // Future<bool> getDetailsById(String id) async {
  //   _isGetDetailsLoading = true;
  //   notifyListeners();
  //   try {
  //     http.Response _response = await http.get(
  //         'https://book-swap-3492e-default-rtdb.firebaseio.com/books/$id.json');

  //     if (_response.statusCode == 200) {
  //       _allBooks.where((BooksModel model) => model.bookId == id);
  //       _isGetDetailsLoading = false;
  //       notifyListeners();
  //       return true;
  //     }
  //   } catch (e) {
  //     _isGetDetailsLoading = false;
  //       notifyListeners();
  //       return false;
  //   }
  // }
}
