import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Widget untuk menampilkan foto profil
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://example.com/path-to-profile-image.jpg'), // Ganti dengan URL foto profil
            ),
            SizedBox(height: 20),
            // Widget untuk mengubah nama
            ElevatedButton(
              onPressed: () {
                _showChangeNameDialog(context);
              },
              child: Text('Ubah Nama'),
            ),
            // Widget lain untuk mengubah data profil
          ],
        ),
      ),
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Nama'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Nama Baru'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Implementasi untuk menyimpan perubahan nama
                String newName = _nameController.text;
                // Lakukan sesuatu dengan nama yang baru, misalnya update ke server
                // Disini Anda bisa menggunakan fungsi editRecipe dari data_recipes.dart
                // atau membuat fungsi sendiri untuk mengubah data profil.

                // Setelah mengubah nama, tutup dialog
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
