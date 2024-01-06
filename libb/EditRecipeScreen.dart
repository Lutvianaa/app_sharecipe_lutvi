import 'package:flutter/material.dart';
import 'data/data_recipes.dart';
import 'homescreen.dart';

class EditRecipeScreen extends StatelessWidget {
  final Recipe recipe;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _htmController = TextEditingController();
  final TextEditingController _tutorialController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  EditRecipeScreen({required this.recipe}) {
    // Assign existing recipe data to controllers
    _nameController.text = recipe.name;
    _htmController.text = recipe.htm;
    _tutorialController.text = recipe.tutorial;
    _imageController.text = recipe.imageFileName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
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
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image File Name'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to update recipe
          final String name = _nameController.text;
          final String htm = _htmController.text;
          final String tutorial = _tutorialController.text;
          final String imageFileName = _imageController.text;

          if (name.isNotEmpty && htm.isNotEmpty && tutorial.isNotEmpty && imageFileName.isNotEmpty) {
            final updatedRecipe = Recipe(
              name: name,
              htm: htm,
              tutorial: tutorial,
              imageFileName: imageFileName,
            );

            editRecipe(updatedRecipe).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(value)),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill in all fields')),
            );
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}