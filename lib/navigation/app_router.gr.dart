// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i13;
import 'package:tasty_recipes/model/recipe.dart' as _i12;
import 'package:tasty_recipes/view/add_recipe_page.dart' as _i1;
import 'package:tasty_recipes/view/auth_page.dart' as _i2;
import 'package:tasty_recipes/view/comments_page.dart' as _i3;
import 'package:tasty_recipes/view/home_page.dart' as _i4;
import 'package:tasty_recipes/view/profil_admin_page.dart' as _i5;
import 'package:tasty_recipes/view/profil_user_page.dart' as _i6;
import 'package:tasty_recipes/view/recipe_details_page.dart' as _i7;
import 'package:tasty_recipes/view/recipe_to_confirm_page.dart' as _i8;
import 'package:tasty_recipes/view/recipes_page.dart' as _i9;
import 'package:tasty_recipes/view/search_page.dart' as _i10;

/// generated route for
/// [_i1.AddRecipePage]
class AddRecipeRoute extends _i11.PageRouteInfo<void> {
  const AddRecipeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          AddRecipeRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddRecipeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddRecipePage();
    },
  );
}

/// generated route for
/// [_i2.AuthPage]
class AuthRoute extends _i11.PageRouteInfo<void> {
  const AuthRoute({List<_i11.PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.AuthPage();
    },
  );
}

/// generated route for
/// [_i3.CommentsPage]
class CommentsRoute extends _i11.PageRouteInfo<void> {
  const CommentsRoute({List<_i11.PageRouteInfo>? children})
      : super(
          CommentsRoute.name,
          initialChildren: children,
        );

  static const String name = 'CommentsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.CommentsPage();
    },
  );
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomePage();
    },
  );
}

/// generated route for
/// [_i5.ProfileAdminPage]
class ProfileAdminRoute extends _i11.PageRouteInfo<void> {
  const ProfileAdminRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProfileAdminRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileAdminRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.ProfileAdminPage();
    },
  );
}

/// generated route for
/// [_i6.ProfileUserPage]
class ProfileUserRoute extends _i11.PageRouteInfo<void> {
  const ProfileUserRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProfileUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileUserRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProfileUserPage();
    },
  );
}

/// generated route for
/// [_i7.RecipeDetailsPage]
class RecipeDetailsRoute extends _i11.PageRouteInfo<RecipeDetailsRouteArgs> {
  RecipeDetailsRoute({
    required _i12.Recipe recipe,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          RecipeDetailsRoute.name,
          args: RecipeDetailsRouteArgs(
            recipe: recipe,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipeDetailsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecipeDetailsRouteArgs>();
      return _i7.RecipeDetailsPage(
        recipe: args.recipe,
        key: args.key,
      );
    },
  );
}

class RecipeDetailsRouteArgs {
  const RecipeDetailsRouteArgs({
    required this.recipe,
    this.key,
  });

  final _i12.Recipe recipe;

  final _i13.Key? key;

  @override
  String toString() {
    return 'RecipeDetailsRouteArgs{recipe: $recipe, key: $key}';
  }
}

/// generated route for
/// [_i8.RecipeToConfirmPage]
class RecipeToConfirmRoute
    extends _i11.PageRouteInfo<RecipeToConfirmRouteArgs> {
  RecipeToConfirmRoute({
    required _i12.Recipe recipe,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          RecipeToConfirmRoute.name,
          args: RecipeToConfirmRouteArgs(
            recipe: recipe,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'RecipeToConfirmRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecipeToConfirmRouteArgs>();
      return _i8.RecipeToConfirmPage(
        recipe: args.recipe,
        key: args.key,
      );
    },
  );
}

class RecipeToConfirmRouteArgs {
  const RecipeToConfirmRouteArgs({
    required this.recipe,
    this.key,
  });

  final _i12.Recipe recipe;

  final _i13.Key? key;

  @override
  String toString() {
    return 'RecipeToConfirmRouteArgs{recipe: $recipe, key: $key}';
  }
}

/// generated route for
/// [_i9.RecipesPage]
class RecipesRoute extends _i11.PageRouteInfo<void> {
  const RecipesRoute({List<_i11.PageRouteInfo>? children})
      : super(
          RecipesRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecipesRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.RecipesPage();
    },
  );
}

/// generated route for
/// [_i10.SearchPage]
class SearchRoute extends _i11.PageRouteInfo<void> {
  const SearchRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.SearchPage();
    },
  );
}
