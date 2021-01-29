class BooksModel {
  String bookId;
  String bookTitle;
  String bookCover;
  String bookSummary;
  double bookRate;

  BooksModel(
      {this.bookId,
      this.bookTitle,
      this.bookCover ,
      this.bookSummary,
      this.bookRate,});

  factory BooksModel.fromjson(Map<String, dynamic> json, id) {
    return BooksModel(
        bookId: id,
        bookTitle: json['bookTitle'],
        bookCover: json['bookCover'],
        bookSummary: json['bookSummary'],
        bookRate: json['bookRate'],);
  }
}
