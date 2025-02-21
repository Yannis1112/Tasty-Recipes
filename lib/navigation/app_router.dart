import 'package:auto_route/auto_route.dart';

import 'package:tasty_recipes/navigation/app_router.gr.dart';

import '../view/recipe_to_confirm_page.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page, path: '/auth', initial: true), // TODO(erreur): Ce n'est pas la bonne route
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      children: [
        AutoRoute(page: RecipesRoute.page, path: 'recipes', initial: true),
        AutoRoute(page: SearchRoute.page, path: 'search'),
        AutoRoute(page: ProfileAdminRoute.page, path: 'profile-admin'),
        AutoRoute(page: ProfileUserRoute.page, path: 'profile-user'),
      ],
    ),
    AutoRoute(page: AddRecipeRoute.page, path: '/add-recipe'),
    AutoRoute(page: RecipeDetailsRoute.page, path: '/recipe-detail/:recipe'),
    AutoRoute(page: RecipeToConfirmRoute.page, path: '/recipe-to-confirm/:recipe'),
  ];
}
