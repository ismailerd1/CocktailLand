import 'package:flutter/material.dart';
import 'package:cocktailland/models/cocktail.dart';
import 'package:cocktailland/pages/quiz_dialog.dart';

class DiscoverPage extends StatefulWidget {
  final List<Cocktail> cocktails;
  final List<Cocktail> favoriteCocktails;
  final Function(Cocktail) toggleFavorite;

  const DiscoverPage({
    Key? key,
    required this.cocktails,
    required this.favoriteCocktails,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late TextEditingController _searchController;
  List<Cocktail> _filteredCocktails = [];

  @override
  void initState() {
    super.initState();
    _filteredCocktails = widget.cocktails;
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final searchText = _searchController.text.toLowerCase();
      _filteredCocktails = widget.cocktails.where((cocktail) {
        final name = cocktail.name.toLowerCase();
        return name.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade400,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to cocktailland',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Container(
                  height: 52,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.black,
                      hintText: 'Find your cocktail..',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCocktails.length,
                  itemBuilder: (context, index) {
                    final cocktail = _filteredCocktails[index];
                    final isFavorite = widget.favoriteCocktails.contains(cocktail);
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
                        trailing: IconButton(
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                          iconSize: 30,
                          color: Colors.black,
                          onPressed: () {
                            widget.toggleFavorite(cocktail);
                          },
                        ),
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
