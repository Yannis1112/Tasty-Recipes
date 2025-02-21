import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> getImageUrl(String imagePath) async {
  final storageRef = FirebaseStorage.instance.ref().child(imagePath);
  return await storageRef.getDownloadURL();
}

class RecipeImage extends StatelessWidget {
  final String imagePath;

  const RecipeImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getImageUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(
            Icons.error,
            size: 160,
          );
        } else if (!snapshot.hasData) {
          return const Text("Pas d'image trouvé");
        }

        return Image.network(
          snapshot.data!,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
