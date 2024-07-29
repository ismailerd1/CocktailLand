import 'package:flutter/material.dart';
import 'package:cocktailland/models/cocktail.dart';
import 'package:cocktailland/pages/quiz_dialog.dart';
import 'package:hive/hive.dart';

class MyFavs extends StatefulWidget {
  const MyFavs({super.key, required this.favoriteCocktails, required this.onFavoritesChanged});

  final List<Cocktail> favoriteCocktails;
  final VoidCallback onFavoritesChanged;

  @override
  _MyFavsState createState() => _MyFavsState();
}

class _MyFavsState extends State<MyFavs> {
  List<Cocktail> favoriteCocktails = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCocktails();
  }

  void _loadFavoriteCocktails() async {
    var box = await Hive.box<Cocktail>('favoriteCocktailsBox');
    setState(() {
      favoriteCocktails = box.values.toList();
    });
  }

  @override
  void didUpdateWidget(covariant MyFavs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favoriteCocktails != widget.favoriteCocktails) {
      _loadFavoriteCocktails();
    }
  }


  void _clearAllCocktails() async {
  var box = await Hive.openBox<Cocktail>('favoriteCocktailsBox');
  await box.clear();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade400,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'My favourites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favoriteCocktails.length,
                  itemBuilder: (context, index) {
                    final cocktail = favoriteCocktails[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade700, width: 2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        title: Center(
                          child: Text(
                            cocktail.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        tileColor: Colors.amber.shade800,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuizDialog(cocktail: cocktail);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}