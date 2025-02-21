import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tasty_recipes/model/ingredient.dart';
import 'package:tasty_recipes/model/recipe.dart';
import 'package:tasty_recipes/navigation/app_router.gr.dart';

@RoutePage()
class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({Key? key}) : super(key: key);

  @override
  _ProfileAdminPageState createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  late Future<List<String>> _diets =
      FirebaseFirestore.instance.collection('diets').get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['diet'] as String).toList();
  });

  late Future<List<String>> _tabs =
      FirebaseFirestore.instance.collection('tabs').get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  });

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user?.photoURL ?? '',
                      ),
                      backgroundColor: Colors.transparent,
                      radius: 40,
                    ),
                    const SizedBox(width: 50),
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                FirebaseAuth
                                        .instance.currentUser?.displayName ??
                                    'Nom',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '(administrateur)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Régimes alimentaires',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            final dietController = TextEditingController();
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 16,
                                right: 16,
                                top: 16,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: dietController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nom du régime alimentaire',
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (dietController.text.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('diets')
                                              .add({
                                            'name': dietController.text,
                                          });
                                          setState(() {
                                            _diets = FirebaseFirestore.instance
                                                .collection('diets')
                                                .get()
                                                .then((snapshot) {
                                              return snapshot.docs
                                                  .map(
                                                    (doc) =>
                                                        doc['name'] as String,
                                                  )
                                                  .toList();
                                            });
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Ajouter'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                FutureBuilder<List<String>>(
                  future: _diets,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Aucun régimes alimentaires trouvés');
                    } else {
                      return Wrap(
                        spacing: 8,
                        children: snapshot.data!.map((diet) {
                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Supprimer le régime alimentaire',
                                    ),
                                    content: const Text(
                                      'Voulez-vous vraiment supprimer ce régime alimentaire ?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Annuler'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('diets')
                                              .where('name', isEqualTo: diet)
                                              .get()
                                              .then((snapshot) {
                                            for (final DocumentSnapshot ds
                                                in snapshot.docs) {
                                              ds.reference.delete();
                                            }
                                          });
                                          setState(() {
                                            _diets = FirebaseFirestore.instance
                                                .collection('diets')
                                                .get()
                                                .then((snapshot) {
                                              return snapshot.docs
                                                  .map(
                                                    (doc) =>
                                                        doc['name'] as String,
                                                  )
                                                  .toList();
                                            });
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Supprimer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Chip(
                              label: Text(diet),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mots clés',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            final dietController = TextEditingController();
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                                left: 16,
                                right: 16,
                                top: 16,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: dietController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nom du mot clé à ajouter',
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (dietController.text.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('tabs')
                                              .add({
                                            'name': dietController.text,
                                          });
                                          setState(() {
                                            _tabs = FirebaseFirestore.instance
                                                .collection('tabs')
                                                .get()
                                                .then((snapshot) {
                                              return snapshot.docs
                                                  .map(
                                                    (doc) =>
                                                        doc['name'] as String,
                                                  )
                                                  .toList();
                                            });
                                          });
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Ajouter'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                FutureBuilder<List<String>>(
                  future: _tabs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Aucun mots clés trouvés');
                    } else {
                      return Wrap(
                        spacing: 8,
                        children: snapshot.data!.map((tab) {
                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Supprimer le mot clé',
                                    ),
                                    content: const Text(
                                      'Voulez-vous vraiment supprimer ce mot clé ?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Annuler'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('tabs')
                                              .where('name', isEqualTo: tab)
                                              .get()
                                              .then((snapshot) {
                                            for (final DocumentSnapshot ds
                                                in snapshot.docs) {
                                              ds.reference.delete();
                                            }
                                          });
                                          setState(() {
                                            _tabs = FirebaseFirestore.instance
                                                .collection('tabs')
                                                .get()
                                                .then((snapshot) {
                                              return snapshot.docs
                                                  .map(
                                                    (doc) =>
                                                        doc['name'] as String,
                                                  )
                                                  .toList();
                                            });
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Supprimer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Chip(
                              label: Text(tab),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recettes à valider',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('recipes')
                      .where('isValidate', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Text('Aucune recette à valider');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.circle,
                              size: 12,
                              color: Colors.grey,
                            ),
                            title: Text(doc['nameRecipe'].toString()),
                            onTap: () {
                              context.router.push(
                                RecipeToConfirmRoute(
                                  recipe: Recipe(
                                    idRecipe: doc.id,
                                    nameRecipe: doc['nameRecipe'].toString(),
                                    imageRecipe: doc['imageRecipe'].toString(),
                                    category: doc['category'].toString(),
                                    totalTime: doc['totalTime'].toString(),
                                    cookingTime: doc['cookingTime'].toString(),
                                    difficulty: doc['difficulty'].toString(),
                                    cost: doc['cost'].toString(),
                                    ingredients: (doc['ingredients'] as List)
                                        .map(
                                          (ingredient) => Ingredient(
                                            name: ingredient['name'] as String,
                                            quantity: ingredient['quantity']
                                                as String,
                                            unit: ingredient['unit'] as String,
                                            unitAbbreviation:
                                                ingredient['unitAbbreviation']
                                                    as String,
                                            alternativeIngredient: ingredient[
                                                    'alternativeIngredient']
                                                as String,
                                          ),
                                        )
                                        .toList(),
                                    steps: List<String>.from(
                                      doc['steps'] as List,
                                    ),
                                    utensils: List<String>.from(
                                      doc['utensils'] as List,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              icon: const Icon(
                                Icons.info,
                                color: Color(0xff236222),
                              ),
                              title: const Text(
                                'Informations du compte',
                                style: TextStyle(
                                  color: Color(0xff236222),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text("Nom d'utilisateur"),
                                      subtitle: Text(
                                        user?.displayName ?? '',
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Adresse email'),
                                      subtitle: Text(user?.email ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                          icon: const Icon(Icons.info),
                          label: const Text('Informations du compte'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (user != null) {
                              const SnackBar(
                                content: Text(
                                  'Erreur lors de la déconnexion',
                                ),
                              );
                              return;
                            }
                            if (!context.mounted) return;
                            await context.router.replaceNamed('/auth');
                          },
                          child: const Text(
                            'Déconnexion',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
