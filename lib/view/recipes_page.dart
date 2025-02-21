import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tasty_recipes/model/ingredient.dart';
import 'package:tasty_recipes/model/recipe.dart';

import '../navigation/app_router.gr.dart';

@RoutePage()
class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recettes populaires',
          style:
              TextStyle(color: Color(0xff236222), fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: FirebaseFirestore.instance
            .collection('recipes')
        .where('isValidate', isEqualTo: true)
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Recipe(
              nameRecipe: data['nameRecipe'] as String,
              imageRecipe: data['imageRecipe'] as String,
              category: data['category'] as String,
              totalTime: data['totalTime'] as String,
              cookingTime: data['cookingTime'] as String,
              difficulty: data['difficulty'] as String,
              cost: data['cost'] as String,
              ingredients: (data['ingredients'] as List)
                  .map((ingredient) => Ingredient(
                        name: ingredient['name'] as String,
                        quantity: ingredient['quantity'] as String,
                        unit: ingredient['unit'] as String,
                        unitAbbreviation:
                            ingredient['unitAbbreviation'] as String,
                        alternativeIngredient:
                            ingredient['alternativeIngredient'] as String,
                      ))
                  .toList(),
              steps: List<String>.from(data['steps'] as List),
              utensils: List<String>.from(data['utensils'] as List),
            );
          }).toList();
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement des recettes'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune recette trouvée'));
          }

          final loadedRecipes = snapshot.data!;

          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: loadedRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    context.router.push(
                      RecipeDetailsRoute(
                        recipe: loadedRecipes[index],
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 170,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: loadedRecipes[index].imageRecipe,
                          width: 150,
                          height: 150,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            size: 160,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            loadedRecipes[index].nameRecipe,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.router.pushNamed('/add-recipe');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: const Text('Ajouter une recette'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
