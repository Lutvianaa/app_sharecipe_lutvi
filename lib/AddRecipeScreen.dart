import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'data/data_recipes.dart';
import 'homescreen.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _htmController = TextEditingController();
  final TextEditingController _tutorialController = TextEditingController();
  File? _file;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

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
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _file == null
                    ? Center(
                  child: Text(
                    'Upload File',
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

          if (name.isNotEmpty && htm.isNotEmpty && tutorial.isNotEmpty && _file != null) {
            final newRecipe = Recipe(
              name: name,
              htm: htm,
              tutorial: tutorial,
              imageFileName: _file!.path,
            );

            // Memanggil fungsi addRecipe untuk mengirim data resep ke server
            String result = await addRecipe(newRecipe); // Perubahan 1: await untuk menunggu hasil

            if (result == 'Recipe added successfully') {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add recipe')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill in all fields and select a file')),
            );
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
