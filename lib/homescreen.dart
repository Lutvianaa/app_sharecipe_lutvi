import 'package:crud_php/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddRecipeScreen.dart';
import 'EditRecipeScreen.dart';
import 'data/data_recipes.dart';
import 'detail_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Recipe>>? _recipes;

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Apakah Anda yakin untuk logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final userManager = Provider.of<UserManager>(context, listen: false);
                userManager.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _recipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                // Navigate to profile screen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              } else if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _recipes = fetchRecipes();
          });
        },
        child: FutureBuilder<List<Recipe>>(
          future: _recipes,
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
                          fit: BoxFit.cover,
                          image: NetworkImage('http://192.168.43.198/api_php/uploads/${recipe.imageFileName}'),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRecipeScreen(recipe: recipe),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _navigateToEditRecipeScreen(context, recipe);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteRecipe(context, recipe);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddRecipeScreen(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddRecipeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecipeScreen(),
      ),
    );
  }

  Future<void> _navigateToEditRecipeScreen(BuildContext context, Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipe: recipe),
      ),
    );

    if (result != null && result) {
      setState(() {
        _recipes = fetchRecipes();
      });
    }
  }

  void _deleteRecipe(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus resep ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                await _performDelete(context, recipe);
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDelete(BuildContext context, Recipe recipe) async {
    try {
      int recipeId = int.parse(recipe.id);
      await deleteRecipe(recipeId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Recipe deleted successfully'),
      ));
      setState(() {
        _recipes = fetchRecipes();
      });
    } catch (e) {
      print('Failed to delete recipe. Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete recipe'),
      ));
    }
  }
}
