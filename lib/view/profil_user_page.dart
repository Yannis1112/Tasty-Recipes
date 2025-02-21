import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({Key? key}) : super(key: key);

  @override
  _ProfileUserPageState createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  final List<String> _selectedDiet = [];
  final List<String> _selectedTab = [];
  late final Future<List<String>> _diets =
      FirebaseFirestore.instance.collection('diets').get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['diet'] as String).toList();
  });

  late final Future<List<String>> _tabs =
      FirebaseFirestore.instance.collection('tabs').get().then((snapshot) {
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  });

  User? user = FirebaseAuth.instance.currentUser;

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
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Régimes alimentaires',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                            onTap: () {
                              setState(() {
                                if (_selectedDiet.contains(diet)) {
                                  _selectedDiet.remove(diet);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user?.uid)
                                      .update({
                                    'diets': _selectedDiet,
                                  });
                                } else {
                                  _selectedDiet.add(diet);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user?.uid)
                                      .update({
                                    'diets': _selectedDiet,
                                  });
                                }
                              });
                            },
                            child: Chip(
                              backgroundColor: _selectedDiet.contains(diet)
                                  ? const Color(0xff94f393)
                                  : Colors.grey[200]!,
                              label: Text(
                                diet,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mots clés',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                            onTap: () {
                              setState(() {
                                if (_selectedTab.contains(tab)) {
                                  _selectedTab.remove(tab);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user?.uid)
                                      .update({
                                    'tabs': _selectedTab,
                                  });
                                } else {
                                  _selectedTab.add(tab);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user?.uid)
                                      .update({
                                    'tabs': _selectedTab,
                                  });
                                }
                              });
                            },
                            child: Chip(
                              backgroundColor: _selectedTab.contains(tab)
                                  ? const Color(0xff94f393)
                                  : Colors.grey[200]!,
                              label: Text(
                                tab,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mes recettes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TODO(add): Ajouter les recettes que l'utilisateur a créée
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
