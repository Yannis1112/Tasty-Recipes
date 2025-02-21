import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasty_recipes/model/ingredient.dart';

@RoutePage()
class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePage();
}

class _AddRecipePage extends State<AddRecipePage> {
  Map<String, bool> selectedDiets = {};

  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeCategoryController =
      TextEditingController();
  final TextEditingController _recipeTotalTimeController =
      TextEditingController();
  final TextEditingController _recipeCookingTimeController =
      TextEditingController();
  final TextEditingController _recipeDifficultyController =
      TextEditingController();
  final TextEditingController _recipeCostController = TextEditingController();
  final TextEditingController _recipeStepsController = TextEditingController();
  final TextEditingController _recipeUtensilsController =
      TextEditingController();
  final TextEditingController _recipeIngredientsController =
      TextEditingController();
  final TextEditingController _recipeQuantityController =
      TextEditingController();
  final TextEditingController _recipeAlternativeIngredientController =
      TextEditingController();

  String _recipeName = '';
  String _recipeImage = '';
  String _recipeCategory = '';
  String _recipeTotalTime = '';
  String _recipeCookingTime = '';
  String _recipeDifficulty = '';
  String _recipeCost = '';
  String _recipeIngredients = '';
  String _recipeQuantity = '';
  String _recipeUnit = '';
  String _recipeAlternativeIngredient = '';
  final List<Ingredient> _recipeIngredientsList = [];
  final List<String> _recipeSteps = [];
  final List<String> _recipeUtensils = [];

  late final Future<List<String>> _tabs =
      FirebaseFirestore.instance.collection('tabs').get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  });

  late final CollectionReference dietsCollection =
      FirebaseFirestore.instance.collection('diets');
  late final Future<List<String>> _diets =
      dietsCollection.get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  });

  Future<void> _saveRecipe() async {
    final CollectionReference recipes =
        FirebaseFirestore.instance.collection('recipes');
    await recipes.add({
      'nameRecipe': _recipeName,
      'imageRecipe': _recipeImage,
      'category': _recipeCategory,
      'totalTime': _recipeTotalTime,
      'cookingTime': _recipeCookingTime,
      'difficulty': _recipeDifficulty,
      'cost': _recipeCost,
      'ingredients': _recipeIngredientsList
          .map(
            (ingredient) => {
              'name': ingredient.name,
              'quantity': ingredient.quantity,
              'unit': ingredient.unit,
              'unitAbbreviation': _recipeUnitAbbreviation,
              'alternativeIngredient': ingredient.alternativeIngredient,
            },
          )
          .toList(),
      'diets': selectedDiets.entries
          .where((entry) => entry.value)
          .map((entry) => dietsCollection.doc(entry.key).path)
          .toList(),
      'steps': _recipeSteps,
      'utensils': _recipeUtensils,
      'isValidate': false,
    });
  }

  String regex =
      r'^[A-Za-zÄÃÅĀÀÂÆÁĖĘĒÊÉÈËŸŪÚŨÙÛÜĪĮÍĨÌÏÎŌÕÓÒÖŒÔẞĆÇČÑäãåāàâæáėęēêéèëÿūúũùûüīįíĩìïîōõóòöœôßćçčñ ]*$';

  Future<String> uploadImage(File image) async {
    try {
      // Crée une référence à l'emplacement où l'image sera stockée
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${image.path.split('/').last}');

      // Télécharge l'image sur Firebase Storage
      final uploadTask = storageRef.putFile(image);

      // Attend la fin du téléchargement
      final snapshot = await uploadTask.whenComplete(() => null);

      // Récupère l'URL de téléchargement de l'image
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Erreur lors du téléchargement de l'image : $e");
      // TODO(verif): Vérifier que l'image existe pas deja dans la base
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUnitsKitchen() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('unitsKitchen').get();
    return snapshot.docs
        .map((doc) => {
              'unit': doc['unit'],
              'abbreviation': doc['abbreviation'],
            })
        .toList();
  }

  String _getAbbreviation(String unit) {
    return _unitsKitchenData
        .firstWhere((element) => element['unit'] == unit)['abbreviation']!;
  }

  @override
  void initState() {
    super.initState();
    _fetchUnitsKitchen().then((units) {
      setState(() {
        _fetchUnitsKitchen().then((units) {
          setState(() {
            _unitsKitchen =
                units.map((unit) => unit['unit'] as String).toList();
            _unitsKitchenData = units
                .map(
                  (unit) => {
                    'unit': unit['unit'] as String,
                    'abbreviation': unit['abbreviation'] as String,
                  },
                )
                .toList();
          });
        });
      });
    });
  }

  List<String> _unitsKitchen = [];
  List<Map<String, String>> _unitsKitchenData = [];
  String _recipeUnitAbbreviation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter une recette',
          style: TextStyle(
            color: Color(0xff236222),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _recipeNameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Nom de la recette',
                        suffixIcon: GestureDetector(
                          onTap: _recipeNameController.clear,
                          child: const Icon(Icons.highlight_remove),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (!RegExp(regex).hasMatch(value)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Veuillez ne pas mettre de chiffres ou de caractères spéciaux',
                                ),
                              ),
                            );
                            return;
                          }

                          _recipeName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              _recipeImage = 'loading';
                            });
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile == null) {
                              setState(() {
                                _recipeImage = '';
                              });
                              return;
                            }
                            final imageFile = File(pickedFile.path);
                            final downloadUrl = await uploadImage(imageFile);
                            setState(() {
                              _recipeImage = downloadUrl;
                            });
                          },
                          child: const Text('Ajouter une image'),
                        ),
                        const SizedBox(height: 20),
                        if (_recipeImage == 'loading')
                          const CircularProgressIndicator()
                        else if (_recipeImage.isNotEmpty)
                          Image.network(
                            _recipeImage,
                            height: 200,
                            width: 200,
                          )
                        else
                          const Text('Aucune image sélectionnée'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<List<String>>(
                      future: _tabs,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<String>> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Erreur: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('Aucune catégorie trouvée');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: snapshot.data!.first,
                            items: snapshot.data!.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue == null) return;
                                _recipeCategoryController.text = newValue;
                                _recipeCategory = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Catégorie de la recette',
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _recipeTotalTimeController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Temps total',
                        suffixIcon: GestureDetector(
                          onTap: _recipeTotalTimeController.clear,
                          child: const Icon(Icons.highlight_remove),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (!RegExp(r'^[0-9h min]*$').hasMatch(value)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Veuillez ne pas mettre de caractères spéciaux',
                                ),
                              ),
                            );
                            return;
                          }
                          _recipeTotalTime = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _recipeCookingTimeController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Temps de cuisson',
                        suffixIcon: GestureDetector(
                          onTap: _recipeCookingTimeController.clear,
                          child: const Icon(Icons.highlight_remove),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (!RegExp(r'^[0-9h min]*$').hasMatch(value)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Veuillez ne pas mettre de caractères spéciaux',
                                ),
                              ),
                            );
                            return;
                          }

                          _recipeCookingTime = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: 'Facile',
                      items: ['Facile', 'Moyenne', 'Difficile']
                          .map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == null) return;
                          _recipeDifficultyController.text = newValue;
                          _recipeDifficulty = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Difficulté de la recette',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: '€',
                      items: ['€', '€€', '€€€'].map((String cost) {
                        return DropdownMenuItem<String>(
                          value: cost,
                          child: Text(
                            cost,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == null) return;
                          _recipeCostController.text = newValue;
                          _recipeCost = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Coût de la recette',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TextField(
                          controller: _recipeIngredientsController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Ajouter des ingrédients',
                            suffixIcon: GestureDetector(
                              onTap: _recipeIngredientsController.clear,
                              child: const Icon(Icons.highlight_remove),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (!RegExp(regex).hasMatch(value)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez ne pas mettre de chiffres ou caractères spéciaux',
                                    ),
                                  ),
                                );
                                return;
                              }
                              _recipeIngredients = value;
                            });
                          },
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 2.75 - 32,
                              child: TextField(
                                controller: _recipeQuantityController,
                                keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Quantité',
                                  suffixIcon: GestureDetector(
                                    onTap: _recipeQuantityController.clear,
                                    child: const Icon(Icons.highlight_remove),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (!RegExp(r'^[0-9]+([.,][0-9]+)?$')
                                        .hasMatch(value)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Veuillez entrer un nombre valide',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    _recipeQuantity = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 1.5 - 32,
                              child: DropdownButtonFormField<String>(
                                value: _unitsKitchen.isNotEmpty
                                    ? _unitsKitchen[0]
                                    : null,
                                items:
                                    _unitsKitchen.asMap().entries.map((entry) {
                                  final unit = entry.value;
                                  return DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue == null) return;
                                    _recipeUnit = newValue;
                                    _recipeUnitAbbreviation =
                                        _getAbbreviation(newValue);
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Unité de mesure',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        TextField(
                          controller: _recipeAlternativeIngredientController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Alternative à l'ingrédient",
                            suffixIcon: GestureDetector(
                              onTap:
                                  _recipeAlternativeIngredientController.clear,
                              child: const Icon(Icons.highlight_remove),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (!RegExp(regex).hasMatch(value)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez ne pas mettre de chiffres ou caractères spéciaux',
                                    ),
                                  ),
                                );
                                return;
                              }
                              _recipeAlternativeIngredient = value;
                            });
                          },
                        ),
                        const SizedBox(height: 7),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (_recipeIngredientsController.text.isEmpty ||
                                  _recipeQuantityController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez remplir le nom et la quantité pour ajouter un ingrédient',
                                    ),
                                  ),
                                );
                                return;
                              }
                              _recipeIngredientsList.add(
                                Ingredient(
                                  name: _recipeIngredients,
                                  quantity: _recipeQuantity,
                                  unit: _recipeUnit,
                                  unitAbbreviation: _recipeUnitAbbreviation,
                                  alternativeIngredient:
                                      _recipeAlternativeIngredient,
                                ),
                              );

                              _recipeIngredientsController.clear();
                              _recipeQuantityController.clear();
                              _recipeAlternativeIngredientController.clear();
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter un ingrédient'),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _recipeIngredientsList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              textColor: Colors.black,
                              title: Text(
                                '${_recipeIngredientsList[index].name} ${_recipeIngredientsList[index].quantity} ${_recipeIngredientsList[index].unit} ${_recipeIngredientsList[index].alternativeIngredient}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _recipeIngredientsList.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceDim
                          .withOpacity(0.5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'La recette contient :',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                return Column(
                                  children: snapshot.data!.map((diet) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          diet,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SegmentedButton<bool>(
                                          segments: const <ButtonSegment<bool>>[
                                            ButtonSegment<bool>(
                                              value: true,
                                              label: Text('Oui'),
                                            ),
                                            ButtonSegment<bool>(
                                              value: false,
                                              label: Text('Non'),
                                            ),
                                          ],
                                          selected: {
                                            selectedDiets[diet] ?? false,
                                          },
                                          onSelectionChanged:
                                              (Set<bool> newSelection) {
                                            setState(() {
                                              selectedDiets[diet] =
                                                  newSelection.first;
                                            });
                                          },
                                          style: const ButtonStyle(
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          const TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  "Si oui, la recette propose-t'elle des alternatives ?",
                              labelStyle: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _recipeStepsController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Ajouter des étapes',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_recipeStepsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez remplir le champ pour ajouter une étape',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (!RegExp(regex)
                                  .hasMatch(_recipeStepsController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez ne pas mettre de caractères spéciaux',
                                    ),
                                  ),
                                );
                                return;
                              }

                              _recipeSteps.add(_recipeStepsController.text);
                              _recipeStepsController.clear();
                            });
                          },
                          child: const Icon(Icons.add_circle_outline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _recipeSteps.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          textColor: Colors.black,
                          title: Text(_recipeSteps[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _recipeSteps.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    TextField(
                      controller: _recipeUtensilsController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Ajouter des ustensiles',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_recipeUtensilsController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez remplir le champ pour ajouter un ustensile',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (!RegExp(regex)
                                  .hasMatch(_recipeStepsController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez ne pas mettre de caractères spéciaux',
                                    ),
                                  ),
                                );
                                return;
                              }
                              _recipeUtensils.add(
                                _recipeUtensilsController.text,
                              );
                              _recipeUtensilsController.clear();
                            });
                          },
                          child: const Icon(Icons.add_circle_outline),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _recipeUtensils.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          textColor: Colors.black,
                          title: Text(_recipeUtensils[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _recipeUtensils.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_recipeName.isEmpty ||
                            _recipeImage.isEmpty ||
                            _recipeTotalTime.isEmpty ||
                            _recipeCookingTime.isEmpty ||
                            _recipeCost.isEmpty ||
                            _recipeIngredientsList.isEmpty ||
                            _recipeSteps.isEmpty ||
                            _recipeUtensils.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Veuillez remplir tous les champs',
                              ),
                            ),
                          );
                          return;
                        }
                        _saveRecipe();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Recette enregistrée',
                            ),
                          ),
                        );
                        context.router.maybePop();
                        _recipeNameController.clear();
                        _recipeCategoryController.clear();
                        _recipeTotalTimeController.clear();
                        _recipeCookingTimeController.clear();
                        _recipeDifficultyController.clear();
                        _recipeCostController.clear();
                        _recipeStepsController.clear();
                        _recipeUtensilsController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text('Enregistrer la recette'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
