import 'package:hive/hive.dart';

part 'cocktail.g.dart';

@HiveType(typeId: 0)
class Cocktail {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<String> ingredients;

  @HiveField(2)
  final String preparation;


  Cocktail({required this.name, 
            required this.ingredients,
            required this.preparation});
}


