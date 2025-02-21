import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasty_recipes/model/ingredient.dart';
import 'package:tasty_recipes/model/recipe.dart';

@RoutePage()
class RecipeToConfirmPage extends StatefulWidget {
  const RecipeToConfirmPage({required this.recipe, super.key});

  final Recipe recipe;

  @override
  State<RecipeToConfirmPage> createState() => _RecipeToConfirmPage();
}

class _RecipeToConfirmPage extends State<RecipeToConfirmPage> {
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recette à valider',
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
                      Icon(
                        Icons.warning,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ingrédients contenant du gluten',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
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

                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('recipes')
                                .doc(recipe.idRecipe)
                                .update({'isValidate': true});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Recette validée',
                                ),
                              ),
                            );
                            // TODO(admin): envoyer une notif à l'utilisateur où la recette à été ajoutée
                            // TODO(do): await context.router.maybePop();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 0),
                            foregroundColor: Colors.green[900],
                            backgroundColor: Colors.lightGreen[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            'Valider la recette',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // TODO(do): await context.router.maybePop();
                            await FirebaseFirestore.instance
                                .collection('recipes')
                                .doc(recipe.idRecipe).delete();
                            // TODO(admin): envoyer une notif à l'utilisateur où la recette à été supprimée
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 0),
                            foregroundColor: Colors.red[900],
                            backgroundColor: Colors.red[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            'Supprimer la recette',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
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
