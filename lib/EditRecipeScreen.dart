import 'package:flutter/material.dart';
import 'data/data_recipes.dart';
import 'homescreen.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  EditRecipeScreen({required this.recipe});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _htmController = TextEditingController();
  final TextEditingController _tutorialController = TextEditingController();
  File? _file;
  String? _previewImagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.recipe.name;
    _htmController.text = widget.recipe.htm;
    _tutorialController.text = widget.recipe.tutorial;
    _previewImagePath = 'http://192.168.43.198/api_php/uploads/${widget.recipe.imageFileName}';
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _previewImagePath = null;
      });
    }
  }

  Future<String> _performEdit(BuildContext context, Recipe recipe) async {
    try {
      if (_file != null) {
        // Periksa jika ada file baru, lakukan edit dengan gambar baru
        String result = await editRecipeWithImage(recipe, _file!);
        return result;
      } else {
        // Jika tidak ada file baru, lakukan edit tanpa mengubah gambar
        String result = await editRecipe(recipe);
        return result;
      }
    } catch (e) {
      print('Failed to update recipe. Error: $e');
      throw Exception('Failed to update recipe');
    }
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
            // Menampilkan gambar resep yang ada
            Image.network(
              'http://192.168.43.198/api_php/uploads/${widget.recipe.imageFileName}',
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
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
            // Opsi untuk mengunggah file gambar baru
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _previewImagePath != null
                    ? Image.network(
                  _previewImagePath!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
                    : _file == null
                    ? Center(
                  child: Text(
                    'Upload New File',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : Center(
                  child: Text(
                    'File Selected: ${_file!.path}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String name = _nameController.text;
          final String htm = _htmController.text;
          final String tutorial = _tutorialController.text;

          if (name.isNotEmpty && htm.isNotEmpty && tutorial.isNotEmpty) {
            final updatedRecipe = Recipe(
              id: widget.recipe.id,
              name: name,
              htm: htm,
              tutorial: tutorial,
              imageFileName: _file != null ? _file!.path : widget.recipe.imageFileName,
            );

            try {
              String result = await _performEdit(context, updatedRecipe);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update recipe: $e')),
              );
            }
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
