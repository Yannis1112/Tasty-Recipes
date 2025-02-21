import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasty_recipes/model/ingredient.dart';
import 'package:tasty_recipes/model/recipe.dart';

import 'package:tasty_recipes/navigation/app_router.gr.dart';

@RoutePage()
class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({required this.recipe, super.key});

  final Recipe recipe;

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  int _selectedStars = 0;

  late final Future<List<String>> _diets =
      FirebaseFirestore.instance.collection('diets').get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['diet'] as String).toList();
  });

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails de la recette',
          style: TextStyle(
            color: Color(0xff236222),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColoredBox(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    recipe.imageRecipe,
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.nameRecipe,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(4, (index) {
                      return Icon(Icons.star, color: Colors.green.shade900);
                    })
                      ..add(
                        Icon(Icons.star_border, color: Colors.green.shade900),
                      ),
                  ),

                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      context.router.push(
                        CommentsRoute(),
                        // TODO(recipe): Passer le nom de la recette
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.green.shade900,
                        ),
                        Text(
                          '41 commentaires',
                          // TODO(commentates): Remplacer avec le nombre de commentaires
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Infos préparation
                  Text(
                    'Temps de préparation : ${recipe.totalTime}\n'
                    'Temps de cuisson : ${recipe.cookingTime}\n'
                    'Difficulté : ${recipe.difficulty}\n'
                    'Coût : ${recipe.cost}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    // TODO(admin): Add the warning icon
                    children: [
                      FutureBuilder<List<String>>(
                        future: _diets,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text(
                              'Aucun régime alimentaire trouvé',
                            );
                          } else {
                            // TODO(diets): Afficher les régimes alimentaires
                            // Diet == null
                            final trueDiets = snapshot.data!
                                .where((diets) => recipe.diets?[diets] == true)
                                .toList();
                            return Column(
                              children: trueDiets.map((diet) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      diet,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildSectionTitle('Ingrédients', context),
                  _buildListIngredients(recipe.ingredients),

                  const SizedBox(height: 16),

                  _buildSectionTitle('Ustensiles', context),
                  _buildGrid(recipe.utensils),

                  const SizedBox(height: 16),

                  _buildSectionTitle('Préparation', context),
                  for (var i = 0; i < recipe.steps.length; i++)
                    _buildStep('Étape ${i + 1}', recipe.steps[i]),

                  const SizedBox(height: 16),

                  _buildSectionTitle('Commentaires', context),
                  Row(
                    children: [
                      const Text(
                        'Donnez votre avis :',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStars = index + 1;
                              });
                            },
                            child: Icon(
                              index < _selectedStars
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.green.shade900,
                              size: 32,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Laissez un commentaire',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSectionTitle(String title, BuildContext? la) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(la!).colorScheme.primary,
    ),
  );
}

Widget _buildGrid(List<String> items) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            items[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildListIngredients(List<Ingredient> items) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      mainAxisExtent: 100,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${items[index].quantity} ${items[index].unitAbbreviation}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                items[index].name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildStep(String step, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
