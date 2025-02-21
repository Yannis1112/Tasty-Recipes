import 'dart:ui';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:tasty_recipes/viewModel/viewmodel_auth.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final ViewModelAuth _viewModelAuth = ViewModelAuth();

  @override
  Widget build(BuildContext context) {
    _viewModelAuth.isUserAlreadyAuthenticated(context);
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),
          _buildBlurredBackdrop(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fond_tasty.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBlurredBackdrop() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          _buildLogo(),
          const SizedBox(height: 20),
          _buildTitle(),
          const Spacer(),
          _buildSocialButton(
            icon: Icons.facebook,
            text: 'Continuer avec Facebook',
            backgroundColor: Colors.blue[800]!,
            textColor: Colors.white,
            onPressed: () async {
              // TODO(error): Implement Facebook authentication
              //await _viewModelAuth.signInWithFacebook(context);
            },
          ),
          const SizedBox(height: 15),
          _buildSocialButton(
            imageIcon: const AssetImage('assets/google1.png'),
            text: 'Continuer avec Google',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            borderColor: Colors.grey,
            onPressed: () async {
              _viewModelAuth.signInWithGoogle(context);
            },
          ),
          const SizedBox(height: 15),
          _buildSocialButton(
            imageIcon: const AssetImage("assets/twitter.png"),
            text: 'Continuer avec Twitter',
            backgroundColor: Colors.white,
            textColor: Colors.blue,
            borderColor: Colors.grey,
            onPressed: () {},
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/icon.png',
      width: 260,
      height: 260,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Tasty Recipes',
      style: TextStyle(
        color: Color(0xff236222),
        fontSize: 42,
        fontFamily: 'PlayfairDisplay',
      ),
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    AssetImage? imageIcon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color borderColor = Colors.transparent,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 325,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: textColor),
            if (imageIcon != null) Image(image: imageIcon, width: 24, height: 24),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
