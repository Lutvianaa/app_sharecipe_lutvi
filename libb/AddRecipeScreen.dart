import 'package:flutter/material.dart';
import 'data/data_recipes.dart';
import 'homescreen.dart';

class AddRecipeScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _htmController = TextEditingController();
  final TextEditingController _tutorialController = TextEditingController();
  final TextEditingController _imageController = TextEditingController(); // Tambahkan controller untuk nama file gambar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _htmController,
              decoration: InputDecoration(labelText: 'HTM'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _tutorialController,
              decoration: InputDecoration(labelText: 'Tutorial'),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _imageController, // Gunakan controller untuk input nama file gambar
              decoration: InputDecoration(labelText: 'Image File Name'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String name = _nameController.text;
          final String htm = _htmController.text;
          final String tutorial = _tutorialController.text;
          final String imageFileName = _imageController.text; // Dapatkan nama file gambar dari input

          if (name.isNotEmpty && htm.isNotEmpty && tutorial.isNotEmpty && imageFileName.isNotEmpty) {
            final newRecipe = Recipe(
              name: name,
              htm: htm,
              tutorial: tutorial,
              imageFileName: imageFileName, // Gunakan nama file gambar dari input
            );

            addRecipe(newRecipe);

            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill in all fields')),
            );
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Icon(Icons.save),
      ),
    );
  }
}