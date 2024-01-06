import 'package:http/http.dart' as http;
import 'dart:convert';

// Read Data
Future<List<Recipe>> fetchRecipes() async {
  final response = await http.get(Uri.parse('http://10.10.24.17/api_php/recipes_api.php'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((e) => Recipe.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load recipes');
  }
}
// Add Data
Future<String> addRecipe(Recipe recipe) async {
  final response = await http.post(
    Uri.parse('http://10.10.24.17/api_php/recipes_api.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': recipe.name,
      'htm': recipe.htm,
      'tutorial': recipe.tutorial,
      'image': recipe.imageFileName,
    }),
  );

  if (response.statusCode == 200) {
    return 'Recipe added successfully';
  } else {
    throw Exception('Failed to add recipe');
  }
}

// Edit Data
Future<String> editRecipe(Recipe recipe) async {
  final response = await http.put(
    Uri.parse('http://10.10.24.17/api_php/recipes_api.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': recipe.name,
      'htm': recipe.htm,
      'tutorial': recipe.tutorial,
      'image': recipe.imageFileName,
    }),
  );

  if (response.statusCode == 200) {
    return 'Recipe updated successfully';
  } else {
    throw Exception('Failed to update recipe');
  }
}

// Delete Data
Future<String> deleteRecipe(int recipeId) async {
  final response = await http.delete(
    Uri.parse('http://10.10.24.17/api_php/recipes_api.php?id=$recipeId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return 'Recipe deleted successfully';
  } else {
    throw Exception('Failed to delete recipe');
  }
}


class Recipe {
  final String name;
  final String htm;
  final String tutorial;
  final String imageFileName; // Tambahkan field untuk nama file gambar

  Recipe({
    required this.name,
    required this.htm,
    required this.tutorial,
    required this.imageFileName,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      htm: json['htm'],
      tutorial: json['tutorial'],
      imageFileName: json['image'], // Assign nama file gambar dari response API
    );
  }
}
