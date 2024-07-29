// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cocktailland/models/cocktail.dart';

class QuizDialog extends StatefulWidget {
  final Cocktail cocktail;

  const QuizDialog({super.key, required this.cocktail});

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  List<String> selectedIngredients = [];

  bool showAnswer = false;
  bool isCorrect = false;

  final List<String> alcohols = ['Whiskey', 'Vodka', 'Rum','Gin','Tequila','Wine','Beer','Brandy','Wine','Absinthe'];
  final List<String> vermouths = ['Sweet Vermouth', 'Dry Vermouth','Bianco','Rosato'];
  final List<String> liquers = ['Triple Sec','Amaretto','Amaro','Aperol','Campari','Chambord ','Coffee Liqueur','malibu','Drambuie ','Irish Cream','Limoncello ','Jagermeister'];
  final List<String> juices = ['Orange Juice', 'Lime Juice','Apple Juice','Cranberry Juice','Grape Juice','Grapefruit Juice','Pomegranate Juice','Pineapple Juice','Tomato Juice'];
    final List<String> syrupes = ['Simple syrup','Maple syrup','Demerara Syrup','Grenadine','Orgeat','Vanilla','Honey Syrup','Passionfruit','ginger'];
  final List<String> others = ['Sugar cube','bitter', 'Mint', 'Soda Water','salt','black pepper','lime/lemon','egg white','other'];
  final List<String> methods = ['Stir','shake','built-in','strain','muddling','layering','blend'];

  void checkAnswer() {
    setState(() {
      isCorrect = selectedIngredients.toSet().containsAll(widget.cocktail.ingredients) &&
          widget.cocktail.ingredients.toSet().containsAll(selectedIngredients);
      showAnswer = true;
    });
  }

  Widget buildIngredientCategory(String category, List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ingredients.map((ingredient) {
              final isSelected = selectedIngredients.contains(ingredient);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedIngredients.remove(ingredient);
                    } else {
                      selectedIngredients.add(ingredient);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    ingredient,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.cocktail.name,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.amber.shade600,
      content: SingleChildScrollView(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select the ingredients:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              buildIngredientCategory('Alcohols', alcohols),
              buildIngredientCategory('Vermouths', vermouths),
              buildIngredientCategory('Liquers', liquers),
              buildIngredientCategory('Juices', juices),
              buildIngredientCategory('Others', others),
              buildIngredientCategory('Method', methods),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 124, 184, 237),
                ),
                child: Text('Submit / Show answer'),
              ),
              if (showAnswer)
                Column(
                  children: [
                    Text(
                      isCorrect ? 'Correct!' : 'Wrong!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green : Colors.red),
                    ),
                    if (!isCorrect)
                      Column(
                        children: [
                          Text('Correct Ingredients:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          ...widget.cocktail.ingredients
                              .map((ingredient) => Text(ingredient))
                              .toList(),
                          SizedBox(height: 10),
                          Text('Preparation:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(widget.cocktail.preparation),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}