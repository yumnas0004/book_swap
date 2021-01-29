import 'package:book_swap/constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class LibraryCard extends StatelessWidget {
  final String bookCover;
  final String bookTitle;
  final double bookRate;

  LibraryCard({
    @required this.bookCover,
    @required this.bookTitle , 
    @required this.bookRate
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: scaffoldBackgroundColor,
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Image(
              fit: BoxFit.fill,
              image: bookCover == null ? AssetImage('images/book_icon.png') : NetworkImage(bookCover),
            ),
          ),
          Expanded(
            // flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                bookTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              // flex: 1,
              child: SmoothStarRating(
                  allowHalfRating: true,
                  onRated: (v) {},
                  starCount: 5,
                  rating: bookRate / 2,
                  size: 25.0,
                  isReadOnly: true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing: 0.0))
        ],
      ),
    );
  }
}
