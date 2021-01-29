import 'package:book_swap/auth/authentication.dart';
import 'package:book_swap/models/books/books_controller.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with AuthModel , BooksController {}