import 'package:book_swap/models/main_scopedmodel.dart';
import 'package:book_swap/screens/navigationBar/details_screen.dart';
import 'package:book_swap/widgets/library_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:book_swap/responsive/responsive.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Favorite'),),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ScopedModelDescendant(
            builder: (context, child, MainModel model) =>
                buildFavoriteLibraryItem( model , data)),
      ),
      
    );
  }
  
  buildFavoriteLibraryItem( MainModel model , MediaQueryData data ) {
    if (model.isGetFavoriteBooksLoading== true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (model.favoriteBooks.isEmpty) {
      return Center(
        child: Text('No favorite books'),
      );
    } else {
      return GridView.builder(
          itemCount: model.favoriteBooks.length,
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
                bookCover: model.favoriteBooks[i].bookCover,
                bookTitle: model.favoriteBooks[i].bookTitle,
                bookRate: model.favoriteBooks[i].bookRate,
              ),
            );
          });
    }
  }
}