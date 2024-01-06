import 'package:flutter/material.dart';
import 'AddRecipeScreen.dart';
import 'EditRecipeScreen.dart';
import 'data/data_recipes.dart';
import 'detail_recipe_screen.dart'; // Impor file detail_recipe_screen.dart di sini

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    recipe.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    recipe.htm,
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Rounded border
                      image: DecorationImage(
                        fit: BoxFit.fitWidth, // Sesuaikan proporsi gambar
                        alignment: Alignment.center,
                        image: AssetImage('assets/${recipe.imageFileName}'),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigasi ke DetailRecipeScreen saat item diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailRecipeScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _navigateToAddRecipeScreen(context);

            },

            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  // Fungsi untuk menavigasi ke halaman tambah resep
  void _navigateToAddRecipeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipeScreen(), // Gantikan dengan halaman tambah resep yang sesuai
      ),
    );
  }
}