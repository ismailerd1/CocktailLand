import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cocktailland/pages/add_cocktail.dart';
import 'package:cocktailland/pages/discover_page.dart';
import 'package:cocktailland/pages/myfavs.dart';
import 'package:cocktailland/models/cocktail.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyNavbar extends StatefulWidget {
  const MyNavbar({Key? key}) : super(key: key);

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _selectedIndex = 1;
  List<Cocktail> favoriteCocktails = [];
  List<Cocktail> cocktails = [      Cocktail(name: 'Margarita', ingredients: ['Tequila', 'Lime Juice', 'Triple Sec','shake'], preparation: 'just shake it'),
                                    Cocktail(name: 'Martini', ingredients: ['Gin', 'Dry Vermouth','shake'], preparation: 'just shake it'),
                                    Cocktail(name: 'Negroni', ingredients: ['Gin', 'Campari','Sweet vermouth','stir'], preparation: 'just shake it'),
                                    Cocktail(name: 'whiskey sour', ingredients: ['Whiskey', 'lime juice','simple syrup','egg white','shake'], preparation: 'just shake it'),
                                    Cocktail(name: 'Daiquiri', ingredients: ['Rum','lime juice','simple syrup','shake'], preparation: 'just shake it'),];

  @override
  void initState() {
    super.initState();
    _loadCocktails();
  }

  void _loadCocktails() async {
    var cocktailBox = await Hive.box<Cocktail>('cocktailsBox');
    var favoriteBox = await Hive.box<Cocktail>('favoriteCocktailsBox');
    setState(() {
      cocktails = cocktailBox.values.toList();
      favoriteCocktails = favoriteBox.values.toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleFavorite(Cocktail cocktail) async {
    var box = await Hive.openBox<Cocktail>('favoriteCocktailsBox');
    setState(() {
      if (favoriteCocktails.contains(cocktail)) {
        favoriteCocktails.remove(cocktail);
        box.delete(cocktail.name);
      } else {
        favoriteCocktails.add(cocktail);
        box.put(cocktail.name, cocktail);
      }
    });
  }

  void _updateFavorites() {
    setState(() {
      favoriteCocktails = Hive.box<Cocktail>('favoriteCocktailsBox').values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          addcocktail(onCocktailAdded: _loadCocktails),
          DiscoverPage(
            cocktails: cocktails,
            favoriteCocktails: favoriteCocktails,
            toggleFavorite: (cocktail) {
              _toggleFavorite(cocktail);
              _updateFavorites();
            },
          ),
          MyFavs(
            favoriteCocktails: favoriteCocktails,
            onFavoritesChanged: _updateFavorites,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.amber.shade900,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
        child: GNav(
          backgroundColor: Colors.amber.shade900,
          iconSize: 32,
          onTabChange: _onItemTapped,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          tabs: [
            GButton(
              icon: Icons.add,
            ),
            GButton(
              icon: Icons.search,
            ),
            GButton(
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }
}