import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasty_recipes/navigation/app_router.gr.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    isUserAdmin();
  }

  int currentPageIndex = 0;
  bool isAdmin = false;
  User? user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>> actualUser = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  Future<void> isUserAdmin() async {
      await actualUser.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data()! as Map<String, dynamic>;
        setState(() {
          isAdmin = data['admin'] == true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [
        const RecipesRoute(),
        const SearchRoute(),
        if(isAdmin) const ProfileAdminRoute() else const ProfileUserRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(
                label: 'Recettes',
                icon: Icon(Icons.book_outlined),
                activeIcon: Icon(Icons.book),
              ),
              BottomNavigationBarItem(
                label: 'Rechercher',
                icon: Icon(Icons.search),
              ),
              BottomNavigationBarItem(
                label: 'Profil',
                icon: Icon(Icons.account_circle_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
